extends Area

signal out_screen
export (float) var speed := 0.0

export (int) var calories := 10

var effects := {}

onready var options = [
	{"object": $Position3D/cake, "calories": 100, "effects": {}},
	{"object": $Position3D/coke, "calories": 80, "effects": {"gas": 100}},
	{"object": $Position3D/hotdog, "calories": 60, "effects": {}},
	{"object": $Position3D/pizza, "calories": 30, "effects": {}}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	add_to_group("pickables")
	pass # Replace with function body.

func randomize_object() -> void:
	var opt = randi() % options.size()
	for c in $Position3D.get_children():
		c.visible = false
	
	options[opt]["object"].visible = true
	effects = options[opt]["effects"]
	calories = options[opt]["calories"]
	
	pass

func _process(delta: float) -> void:
	translate(Vector3.BACK * delta * speed)
	$Position3D.rotate(Vector3.UP, 0.05)


func _on_VisibilityNotifier_screen_exited() -> void:
	emit_signal('out_screen')
	queue_free()


func _on_Pickable_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.apply_effects(effects)
		queue_free() # do some effects
