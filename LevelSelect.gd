extends Node2D

# Buttons
@onready var level_buttons = [
	$CanvasLayer/Tutorial,
	$CanvasLayer/MainGame,
]
@onready var back_button = $CanvasLayer/Back

# Musics
@onready var hover_sound = $CanvasLayer/HoverSound

# Hover scale factor
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

#
func _ready():
	# Connect back button signals
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)

	#back_button.mouse_entered.connect(_on_button_hovered)

	#for i in range(level_buttons.size()):
		#var button = level_buttons[i]
		#button.disabled = false
		#button.connect("pressed", Callable(self, "_on_level_pressed").bind(i + 1))
		#button.mouse_entered.connect(_on_button_hovered)

	#if music != null and not music.playing:
		#music.play()
#
#func _on_button_hovered():
	#if hover_sound != null:
		#hover_sound.play()
#
#func _on_level_pressed(level_num):
	## Load the corresponding level scene
	#get_tree().change_scene_to_file("res://Level%d.tscn" % level_num)
#
func _on_back_pressed():
	# Go back to Main Menu
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func _on_back_hover():
	if hover_sound != null: hover_sound.play()
	back_button.modulate = Color(1, 1, 0.7)
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.modulate = Color(1, 1, 1)
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
