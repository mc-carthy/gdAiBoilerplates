extends Spatial


var nav : Navigation
var target : Spatial

var move_speed = 10.0
var move_vec : Vector3

func _ready():
	target = get_tree().get_nodes_in_group("target")[0]
	nav = get_tree().get_nodes_in_group("navigation")[0]

func _physics_process(delta):
	update_move_vec()
	global_translate(move_vec * move_speed * delta)

func update_move_vec():
	var path = nav.get_simple_path(global_transform.origin, target.global_transform.origin)
	if path.size() > 1:
		var dir: Vector3 = path[1] - global_transform.origin
		dir.y = 0
		dir = dir.normalized()
		move_vec = dir
