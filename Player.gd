extends KinematicBody

signal updated_status(energy, fat)

# only side movements
var target := Vector3.ZERO
var target_cal := 0
export (float) var mass := 10.0
export (float) var side_speed := 2.5 # impulse from commands
export (float) var follow_speed := 2.0

var velocity := Vector3.ZERO

var action_time := 0.0
export (float) var threshold := 0.005

export (float) var energy_consumption = 5.0
var energy := 100.0
var fat := 0.0

#var elapsed_time := 0.0
#var consumption_threshold := 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	set_process(false)

func initialize() -> void:
	visible = true
	set_process(true)
	target = Vector3.ZERO
	target_cal = 0
	velocity = Vector3.ZERO
	energy = 100.0
	fat = 0.0

# I should process only one row at a time (not the last added)
func choose_target(pickable) -> void:
	var calories = pickable.effects["calories"]
	if calories > target_cal:
		target = Vector3(pickable.transform.origin.x, 0, 0)
		target_cal = calories
		pickable.connect("out_screen", self, "_reset_target", [pickable])

func _reset_target(pickable) -> void:
	target_cal = 0.0

func _process(delta: float) -> void:
	energy -= delta * energy_consumption
	fat = max(0.0, fat - delta * energy_consumption)
	emit_signal('updated_status', energy, fat)

func _physics_process(delta: float) -> void:
	action_time += delta
	if Input.is_action_just_pressed('ui_left'):
		action_time = 0.0
		velocity = Vector3(-side_speed, 0,0)
	elif Input.is_action_just_pressed('ui_right'):
		action_time = 0.0
		velocity = Vector3(side_speed, 0,0)
	elif (target - transform.origin).length() > 0.1 and action_time > threshold:
		var desired_velocity = (target - transform.origin).normalized() * side_speed
		var steering = (desired_velocity - velocity) / mass
		velocity += steering
	else:
		velocity = Vector3.ZERO
#	else:
#		transform.origin 
	look_at(transform.origin + velocity + Vector3(0,0,-2), Vector3.UP)
	
	velocity = move_and_slide(velocity)
	
	#transform.origin = transform.origin.linear_interpolate(target, side_speed)

func apply_effects(effect: Dictionary) -> void:
	energy += effect['calories']
	if energy > 100.0:
		var extra = energy - 100.0 
		energy = 100.0
		fat += extra /2.0
#	emit_signal('updated_status', energy, fat) # emit by process at any time (I am not sure it is good as it emits continuosly)
	
	# maange gas fo burps
