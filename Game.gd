extends Spatial

signal spawned_pickable(pickable)

var pickable_scene = preload('res://Pickable.tscn')

export (float) var speed := 5.0 setget _set_speed
export (float) var spawn_interval = 4.0

var elapsed_time := 0.0


func _ready() -> void:
	randomize()
	for s in get_tree().get_nodes_in_group("segments"):
		s.speed = speed
	connect('spawned_pickable', $Player, "choose_target")

func _process(delta: float) -> void:
	elapsed_time += delta
	if elapsed_time > spawn_interval:
		elapsed_time = 0.0
		for pos in get_tree().get_nodes_in_group("spawn_points"): 
			spawn(pos)

func spawn(pos: Position3D) -> void:
	var new_pickable = pickable_scene.instance()
	add_child(new_pickable)
	new_pickable.transform.origin = pos.transform.origin
	new_pickable.speed = speed
	var cal = randi() % 100
	new_pickable.calories = cal
	emit_signal('spawned_pickable', new_pickable)

func _set_speed(new_value: float) -> void:
	speed = new_value
	for s in get_tree().get_nodes_in_group("segments"):
		s.speed = speed
	for s in get_tree().get_nodes_in_group("pickables"):
		s.speed = speed
