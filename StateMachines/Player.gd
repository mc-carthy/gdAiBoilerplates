extends Character

var move_speed = 30.0
func _physics_process(delta):
	var move_vec = Vector3.ZERO
	move_vec.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	move_vec.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vec = move_vec.normalized()
	move_and_slide(move_speed*move_vec, Vector3.UP)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		for body in $AttackArea.get_overlapping_bodies():
			if body is Character and body != self:
				body.hurt()

func is_dead():
	return false

func hurt():
	print('player hurt')
