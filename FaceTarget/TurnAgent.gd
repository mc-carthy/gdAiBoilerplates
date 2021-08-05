extends Spatial



var target : Spatial
func _ready():
	target = get_tree().get_nodes_in_group("targets")[0]

func _process(delta):
	pass

func show_red():
	$Graphics/Red.show()
	$Graphics/Yellow.hide()

func show_yellow():
	$Graphics/Red.hide()
	$Graphics/Yellow.show()
