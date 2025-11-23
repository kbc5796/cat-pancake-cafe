extends Node2D  # or Control if your root is Control

# Nodes
@onready var back_button = $Back
@onready var click_sound = $ClickSound  # AudioStreamPlayer with your click sound

# Hover scale
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)

# ----- Back button -----
func _on_back_pressed():
	if click_sound != null:
		click_sound.play()
	await get_tree().create_timer(0.1).timeout  
	get_tree().change_scene_to_file("res://LevelSelect.tscn")


func _on_back_hover():
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
