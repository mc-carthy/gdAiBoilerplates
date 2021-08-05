extends Spatial


onready var fire_point = $FaceTargetY/FaceTargetX/FirePoint
onready var face_target_y = $FaceTargetY
onready var face_target_x = $FaceTargetY/FaceTargetX

var bullet_obj = preload("res://Bullet.tscn")
export var projectile_speed = 40.0
export var projectile_gravity = 9.8

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

func fire():
	if target_out_of_range:
		return
	var bullet_inst = bullet_obj.instance()
	get_tree().get_root().add_child(bullet_inst)
	bullet_inst.global_transform = fire_point.global_transform
	bullet_inst.setup(projectile_speed, projectile_gravity)

func get_aim_at_point():
	return target.global_transform.origin

