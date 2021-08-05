extends Spatial


onready var fire_point = $FaceTargetY/FaceTargetX/FirePoint
onready var face_target_y = $FaceTargetY
onready var face_target_x = $FaceTargetY/FaceTargetX

var bullet_obj = preload("res://Bullet.tscn")
export var projectile_speed = 40.0
export var projectile_gravity = 0.0

var target_out_of_range = false

var target : Spatial
func _ready():
	target = get_tree().get_nodes_in_group("targets")[0]

func _process(delta):
	var aim_at_point = get_aim_at_point()
	target_out_of_range = aim_at_point == null
	if aim_at_point != Vector3.INF:
		face_target_y.face_point(aim_at_point, delta)
		face_target_x.face_point(aim_at_point, delta)

#func _physics_process(delta):
#	print(cur_accuracy)

func fire():
	if target_out_of_range:
		return
	var bullet_inst = bullet_obj.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_transform = fire_point.global_transform
	bullet_inst.setup(projectile_speed, projectile_gravity)

func get_aim_at_point():
	if !target.has_method("get_velocity"):
		return target.global_transform.origin
	if abs(projectile_gravity) < 0.0001:
		return get_aim_at_point_no_gravity()
	else:
		return get_aim_at_point_gravity()

func get_aim_at_point_no_gravity():
	var Pti = target.global_transform.origin
	var Pbi = fire_point.global_transform.origin
	var D = Pti.distance_to(Pbi)
	var Vt = target.get_velocity()
	var St = Vt.length()
	var Sb = projectile_speed
	var cos_theta = Pti.direction_to(Pbi).dot(Vt.normalized())
	var q_root = sqrt(2*D*St*cos_theta + 4*(Sb*Sb - St*St)*D*D )
	var q_sub = (2*(Sb*Sb - St*St))
	var q_left = -2*D*St*cos_theta
	var t1 = (q_left + q_root) / q_sub
	var t2 = (q_left - q_root) / q_sub
	
	var t = min(t1, t2)
	if t < 0:
		t = max(t1, t2)
	if t < 0:
		return Vector3.INF # can't hit, target too fast
	return Vt * t + Pti

const NUM_OF_ITERATIONS = 5
func get_aim_at_point_gravity():
	if !target.has_method('get_velocity'):
		return target.global_transform.origin
	
	var projectile_start_pos = fire_point.global_transform.origin
	var target_start_pos = target.global_transform.origin
	var target_velocity = target.get_velocity()
	var target_future_pos = target_start_pos
	var final_angle = 0.0
	for i in range(NUM_OF_ITERATIONS):
		var dist_to_target = projectile_start_pos.distance_to(target_future_pos)
		var target_height = target_future_pos.y - projectile_start_pos.y
		var angle = get_angle_to_target_point(dist_to_target, target_height, projectile_speed, projectile_gravity)
		if angle == null:
			return Vector3.INF
		
		var vec_to_target = projectile_start_pos - target_future_pos
		vec_to_target.y = 0.0
		var h_dist_to_target = vec_to_target.length()
		var time_in_air = h_dist_to_target / (cos(angle) * projectile_speed)
		
		target_future_pos = target_start_pos + target_velocity * time_in_air
		final_angle = angle
	
	var n = target_future_pos - projectile_start_pos
	var y_rotation = atan2(-n.x, -n.z)
	var predictive_dir = Vector3.FORWARD.rotated(Vector3.RIGHT, final_angle).rotated(Vector3.UP, y_rotation)
	return projectile_start_pos + predictive_dir * 20.0

func get_angle_to_target_point(x, y, S, G):
	if G == 0:
		G = 0.001 # prevent divide by 0
	
	# the equation: atan(s^2 +- sqrt((s^4 - G(Gx^2 + 2S^2y))) / Gx)
	var root = S * S * S * S - G * (G * x * x + 2.0 * y * S * S)
	if root < 0.0:
		print('out of range')
		return null
	root = sqrt(root)
	var sub = G * x
	var s_sq = S * S
	var angle1 = atan((s_sq + root) / sub)
	var angle2 = atan((s_sq - root) / sub)
	
	return min (angle1, angle2) # optimal angle
	#return max (angle1, angle2) # high angle

