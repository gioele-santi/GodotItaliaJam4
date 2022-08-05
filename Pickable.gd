extends Area

signal out_screen
export (float) var speed := 0.0

export (int) var calories := 10

var effects := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("pickables")
	pass # Replace with function body.

func _process(delta: float) -> void:
	translate(Vector3.BACK * delta * speed)


func _on_VisibilityNotifier_screen_exited() -> void:
	emit_signal('out_screen')
	queue_free()


func _on_Pickable_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.apply_effects(effects)
		queue_free() # do some effects
