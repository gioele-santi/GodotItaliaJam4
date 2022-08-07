extends Control

var ok_color := Color("01ac00")
var warn_color := Color("e4da45")
var risk_color := Color("f3473a")

onready var energy_bar := $VBoxContainer/HBoxContainer/Energy/BarBG/TextureProgress
onready var fat_bar := $VBoxContainer/HBoxContainer/Fat/BarBG/TextureProgress

onready var game = $ViewportContainer/Game

onready var controls := $Controls
onready var hud := $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	energy_bar.value = 100.0 # I should pass the inital value instead of typing it
	fat_bar.value = 0.0
	game.gui = self
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _update_distance(distance: float) -> void:
	$VBoxContainer/HBoxContainer2/VSlider.value = distance

func _update_hud(energy: float, fat: float) -> void:
	energy_bar.value = energy
	if energy_bar.value >= 66.0:
		energy_bar.modulate = ok_color
	elif energy_bar.value >= 33.0:
		energy_bar.modulate = warn_color
	else: 
		energy_bar.modulate = risk_color
		
	fat_bar.value = fat
	if fat_bar.value >= 66.0:
		fat_bar.modulate = risk_color 
	elif fat_bar.value >= 33.0:
		fat_bar.modulate = warn_color
	else: 
		fat_bar.modulate = ok_color


func _on_Button_pressed() -> void:
	controls.visible = false
	hud.visible = true
	game.start_game()

func _gameover(success) -> void:
	controls.visible = true
	hud.visible = false
	if success:
		$Controls/Label.text = "You won!"
	else:
		$Controls/Label.text = "You lost!"
	$Controls/Button.text = "Play again"
	# change label text
