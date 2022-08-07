extends MeshInstance

export (float) var speed := 5.0
export (Vector3) var respawn := Vector3(0, 0, -36)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("segments")
	set_process(false)
	pass # Replace with function body.

func _process(delta: float) -> void:
	translate(Vector3.BACK * delta * speed)
	if transform.origin.z > 12.0:
		transform.origin = respawn
#	print(name + " : " + str(transform.origin))

