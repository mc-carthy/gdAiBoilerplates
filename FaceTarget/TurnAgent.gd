extends Spatial

onready var face_target_y = $FaceTargetY
onready var face_target_x = $FaceTargetY/FaceTargetX

var target : Spatial
func _ready():
	target = get_tree().get_nodes_in_group('targets')[0]

func _process(delta):
	var target_pos = target.global_transform.origin
	face_target_y.face_point(target_pos, delta)
	face_target_x.face_point(target_pos, delta)
	
	if face_target_y.is_facing_target(target_pos):
		show_red()
	else:
		show_yellow()

func show_red():
	$Graphics/Red.show()
	$Graphics/Yellow.hide()

func show_yellow():
	$Graphics/Red.hide()
	$Graphics/Yellow.show()
