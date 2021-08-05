extends Spatial

export var vision_cone_arc: float = 60.0

func in_vision_cone(point: Vector3) -> bool:
	var forward = -global_transform.basis.z
	var pos = global_transform.origin
	var dir_to_point = point - pos
	return rad2deg(dir_to_point.angle_to(forward)) <= vision_cone_arc / 2.0

func has_los(point: Vector3) -> bool:
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(global_transform.origin, point, [], 1)
	
	return !result
