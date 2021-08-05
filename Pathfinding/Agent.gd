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
	pass
