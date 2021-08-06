extends Spatial

export var turn_speed: float = 100.0

func face_point(point: Vector3, delta: float):
	var local_point = to_local(point)
	local_point.y = 0.0
	var turn_dir = sign(local_point.x)
	var turn_amount = deg2rad(turn_speed * delta)
	
	rotate_object_local(Vector3.UP, -turn_amount * turn_dir)
