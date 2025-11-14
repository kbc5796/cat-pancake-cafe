extends Node2D

# Buttons
@onready var start_button = $CanvasLayer/StartButton
@onready var quit_button  = $CanvasLayer/QuitButton

# Hover sound
@onready var hover_sound = $CanvasLayer/HoverSound

# Music
@onready var music = $MusicPlayer

# Hover scale factor
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

# Vine sway variables
var sway_time = 0.0
const SWAY_SPEED = 2.0
const SWAY_AMOUNT = 5.0  # pixels

# Store original positions
var start_original_pos : Vector2
var quit_original_pos : Vector2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	start_original_pos = start_button.position
	quit_original_pos  = quit_button.position

	start_button.set_anchors_preset(Control.PRESET_CENTER)
	quit_button.set_anchors_preset(Control.PRESET_CENTER)
	
	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	start_button.mouse_entered.connect(_on_start_hover)
	start_button.mouse_exited.connect(_on_start_exit)
	
	quit_button.pressed.connect(_on_quit_pressed)
	quit_button.mouse_entered.connect(_on_quit_hover)
	quit_button.mouse_exited.connect(_on_quit_exit)

	# Play music
	if music != null and not music.playing:
		music.play()


# ================== Start Button ==================
func _on_start_pressed():
	get_tree().change_scene_to_file("res://MainGame.tscn")

func _on_start_hover():
	if hover_sound != null: hover_sound.play()
	start_button.modulate = Color(1, 1, 0.7)
	start_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_start_exit():
	start_button.modulate = Color(1, 1, 1)
	start_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

# ================== Quit Button ==================
func _on_quit_pressed():
	get_tree().quit()

func _on_quit_hover():
	if hover_sound != null: hover_sound.play()
	quit_button.modulate = Color(1, 1, 0.7)
	quit_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_quit_exit():
	quit_button.modulate = Color(1, 1, 1)
	quit_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)


# ================== Vine Sway Animation ==================
func _process(delta):
	sway_time += delta * SWAY_SPEED
	var offset = sin(sway_time) * SWAY_AMOUNT
	start_button.position.y = start_original_pos.y + offset
	quit_button.position.y  = quit_original_pos.y + offset
