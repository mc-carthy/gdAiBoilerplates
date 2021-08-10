extends KinematicBody


var target : Spatial
var move_speed = 0.0
var exploded = false

var face_target_x
var face_target_y

func setup(_target, _move_speed, turn_speed):
	target = _target
	move_speed = _move_speed
	face_target_x = $FaceTargetY/FaceTargetX
	face_target_y = $FaceTargetY
	
	face_target_x.turn_speed = turn_speed
	face_target_y.turn_speed = turn_speed

func _physics_process(delta):
	if !is_instance_valid(target):
		return
	
	var target_pos = target.global_transform.origin
	face_target_y.face_point(target_pos, delta)
	face_target_x.face_point(target_pos, delta)
	
	var move_dir = -$FaceTargetY/FaceTargetX/DirectionRef.global_transform.basis.z
	var coll = move_and_collide(move_dir * move_speed * delta)
	
	if coll:
		explode()

func explode():
	if exploded:
		return
	exploded = true
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	$Graphics/TrailParticles.emitting = false
	$ExplosionParticles.restart()
	$Graphics/Rocket.hide()
	$DeleteTimer.start()
