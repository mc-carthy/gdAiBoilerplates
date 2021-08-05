extends Spatial


export var fire_rate = 1.0
export var missile_speed = 70.0
export var missile_turn_speed = 150.0

var target : Spatial
var missile_obj = preload("res://Missile.tscn")

func _ready():
	target = get_tree().get_nodes_in_group("targets")[0]
	$FireTimer.connect("timeout", self, "fire_missile")
	$FireTimer.wait_time = fire_rate
	$FireTimer.start()

func fire_missile():
	var missile_inst = missile_obj.instance()
	missile_inst.setup(target, missile_speed, missile_turn_speed)
	missile_inst.global_transform = $LauncherBase/FirePoint.global_transform
	get_tree().get_root().add_child(missile_inst)
