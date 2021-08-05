extends Spatial

onready var VisionManager = $VisionManager

var target: Spatial

func _ready() -> void:
	target = get_tree().get_nodes_in_group('targets')[0]

func _process(delta: float) -> void:
	var target_point = target.global_transform.origin
	if target.has_method('get_aim_at_position'):
		target_point = target.get_aim_at_position()

	if VisionManager.in_vision_cone(target_point) and VisionManager.has_los(target_point):
		$Graphics/Red.show()
		$Graphics/Yellow.hide()
	else:
		$Graphics/Red.hide()
		$Graphics/Yellow.show()
