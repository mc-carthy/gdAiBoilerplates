extends KinematicBody

var gravity = 0.0
var velocity = Vector3()

func setup(move_speed, _gravity):
	gravity = _gravity
	velocity = -global_transform.basis.z * move_speed

var exploded = false
func _physics_process(delta):
	velocity += gravity * Vector3.DOWN * delta
	var coll = move_and_collide(velocity * delta)
	if coll:
		explode()

func explode():
	if exploded:
		return
	exploded = true
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	$ExplosionParticles.restart()
	$MeshInstance.hide()
	$DeleteTimer.start()
	
