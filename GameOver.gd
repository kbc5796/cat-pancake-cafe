extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#print("yes")
	connect_button()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process():

@onready var back_button = $CanvasLayer/Back
@onready var click_sound = $CanvasLayer/ClickSound
@onready var hover_sound = $CanvasLayer/HoverSound

# Hover scale factor
const HOVER_SCALE = 0.30
const NORMAL_SCALE = 0.25

func click_sound_play(timeout):
	click_sound.play()
	await get_tree().create_timer(timeout).timeout
	
func _on_back_pressed():
	# Go back to Main Menu
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://LevelSelect.tscn")
	
func _on_back_hover():
	if hover_sound != null: hover_sound.play()
	back_button.modulate = Color(1, 1, 0.7)
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.modulate = Color(1, 1, 1)
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

func connect_button():
	#print("yes")
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)
