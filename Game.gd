extends Spatial

signal endgame(status)
signal update_distance(value)
signal spawned_pickable(pickable)

var pickable_scene = preload('res://pickables/Pickable.tscn')

export (float) var speed := 6.0 setget _set_speed
export (float) var spawn_interval = 8.0

var spawn_time := 0.0

var gui = null setget _set_gui
onready var player = $Player

var speed_bump_step := 100.0
var distance = 0.0

func _ready() -> void:
	set_process(false)
	randomize()
	for s in get_tree().get_nodes_in_group("segments"):
		s.speed = speed
	connect('spawned_pickable', $Player, "choose_target")
	player.connect('updated_status', self, "player_update_status")

func start_game() -> void:
	speed_bump_step = 100.0
	distance = 0.0
	spawn_time = 6.0
	self.speed = 3.0
	player.initialize()
	set_process(true)
	for s in get_tree().get_nodes_in_group("segments"):
		s.set_process(true)

func _process(delta: float) -> void:
	distance += delta * speed
	if distance >= 500.0:
		gameover(true)
	elif distance > speed_bump_step:
		self.speed += 0.5  # increase speed for each step
		speed_bump_step += 25.0
	emit_signal("update_distance", distance)
	
	print(str(spawn_time) + " >? " + str(spawn_interval))
	spawn_time += delta
	if spawn_time > spawn_interval:
		spawn_time = 0.0
		for pos in get_tree().get_nodes_in_group("spawn_points"): 
			spawn(pos)

func spawn(pos: Position3D) -> void:
	var new_pickable = pickable_scene.instance()
	add_child(new_pickable)
	new_pickable.transform.origin = pos.transform.origin
	new_pickable.speed = speed
	new_pickable.randomize_object()
	emit_signal('spawned_pickable', new_pickable)

func _set_speed(new_value: float) -> void:
	speed = new_value
	
	for s in get_tree().get_nodes_in_group("segments"):
		s.speed = speed
	for s in get_tree().get_nodes_in_group("pickables"):
		s.speed = speed
	if speed != 0.0:
		spawn_interval = 15.0/speed

func _set_gui(new_gui) -> void:
	if gui != null:
		return
	gui = new_gui
	player.connect('updated_status', gui, "_update_hud")
	connect('update_distance', gui, "_update_distance")
	connect('endgame', gui, "_gameover")

func player_update_status(energy: float, fat: float) -> void:
	if energy <= 0.0 or fat >= 100.0:
		gameover(false)

func gameover(success: bool) -> void:
	print("Game Over: " + str(success))
	emit_signal('endgame', success)
	set_process(false)
	self.speed = 0.0
	player.set_process(false)
	for s in get_tree().get_nodes_in_group("segments"):
		s.set_process(false)
	for p in get_tree().get_nodes_in_group("pickables"):
		p.queue_free()
