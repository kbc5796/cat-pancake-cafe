extends Node

@onready var back_button = $CanvasLayer/Back
@onready var click_sound = $CanvasLayer/ClickSound
@onready var hover_sound = $CanvasLayer/HoverSound

# Hover scale factor
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1

# Vine sway variables
var sway_time = 0.0
const SWAY_SPEED = 2.0
const SWAY_AMOUNT = 5.0  # pixels

var start_original_pos : Vector2

func click_sound_play(timeout):
	click_sound.play()
	await get_tree().create_timer(timeout).timeout
	
func _on_back_pressed():
	# Go back to Main Menu
	MusicPlayer.play_main()
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

func _ready():
	connect_button()
	start_original_pos = back_button.position
	
func _process(delta):
	sway_time += delta * SWAY_SPEED
	var offset = sin(sway_time) * SWAY_AMOUNT
	back_button.position.y = start_original_pos.y + offset
