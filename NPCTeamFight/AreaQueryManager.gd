extends Node


var queue = []
var cache = {}

var calculations_per_frame = 1
func _physics_process(delta):
	for _i in range(calculations_per_frame):
		dequeue_area_query()

func request_area_query(npc: FightAgent, position: Vector3, radius: float, collision_mask: int, colliders_to_ignore=[]):
	var key = str(npc)
	if key in cache:
		return
	cache[key] = ""
	var query_data = {
		"npc" : npc,
		"position" : position,
		"radius" : radius,
		"collision_mask" : collision_mask,
		"colliders_to_ignore" : colliders_to_ignore,
		"key": key
	}
	queue.push_back(query_data)

func dequeue_area_query():
	if queue.size() == 0:
		return
	var query_data = queue.pop_front()
	if is_instance_valid(query_data.npc):
		var results = query_area(query_data.position, query_data.radius, query_data.collision_mask, query_data.colliders_to_ignore)
		query_data.npc.update_nearby_npcs(results)
	cache.erase(query_data.key)

func query_area(position: Vector3, radius: float, collision_mask: int, colliders_to_ignore=[]):
	var query_params = PhysicsShapeQueryParameters.new()
	var transform = Transform()
	transform.origin = position
	query_params.set_transform(transform)
	
	var circle_shape = SphereShape.new()
	circle_shape.radius = radius
	query_params.set_shape(circle_shape)
	
	query_params.collision_mask = collision_mask
	var colls_to_ignore = []
	for coll in colliders_to_ignore:
		if is_instance_valid(coll):
			colls_to_ignore.append(coll)
	query_params.exclude = colls_to_ignore
	
	var space_state = get_tree().get_root().get_world().get_direct_space_state()
	var results = space_state.intersect_shape(query_params)
	var hit_colliders = []
	for result in results:
		hit_colliders.append(result.collider)
	return hit_colliders

