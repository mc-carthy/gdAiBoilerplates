extends Spatial

export var vision_cone_arc: float = 60.0

var los: bool = false
var check_this_frame: bool

func _ready() -> void:
	check_this_frame = randi() % 2 == 0

func in_vision_cone(point: Vector3) -> bool:
	var forward = -global_transform.basis.z
	var pos = global_transform.origin
	var dir_to_point = point - pos
	return rad2deg(dir_to_point.angle_to(forward)) <= vision_cone_arc / 2.0

func has_los(point: Vector3) -> bool:
	check_this_frame = !check_this_frame
	if !check_this_frame:
		return los
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(global_transform.origin, point, [], 1)
	los = result.size() == 0
	return los
