extends Spatial

func get_aim_at_position() -> Vector3:
	return global_transform.origin + Vector3.UP * 1.5
