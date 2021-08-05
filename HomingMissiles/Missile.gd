extends KinematicBody


var target : Spatial
var move_speed = 0.0
var exploded = false


func setup(_target, _move_speed, turn_speed):
	target = _target
	move_speed = _move_speed

func _physics_process(delta):
	if !is_instance_valid(target):
		return
	
	var move_dir = -global_transform.basis.z
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
