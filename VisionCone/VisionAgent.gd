extends Spatial

export var vision_cone_arc: float = 60.0
var target: Spatial

func _ready() -> void:
	target = get_tree().get_nodes_in_group('targets')[0]

func _process(delta: float) -> void:
	var target_point = target.global_transform.origin
	if in_vision_cone(target_point):
		$Graphics/Red.show()
		$Graphics/Yellow.hide()
	else:
		$Graphics/Red.hide()
		$Graphics/Yellow.show()

func in_vision_cone(point: Vector3) -> bool:
	var forward = -global_transform.basis.z
	var pos = global_transform.origin
	var dir_to_point = point - pos
	return rad2deg(dir_to_point.angle_to(forward)) <= vision_cone_arc / 2.0
