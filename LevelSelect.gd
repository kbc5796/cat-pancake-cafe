extends Node2D

# Buttons
#@onready var level_buttons = [
	#$CanvasLayer/Tutorial,
	#$CanvasLayer/MainGame,
#]
@onready var level1_button = $CanvasLayer/LevelOne
@onready var level2_button = $CanvasLayer/LevelTwo
@onready var level3_button = $CanvasLayer/LevelThree
@onready var back_button = $CanvasLayer/Back

# Musics
@onready var hover_sound = $CanvasLayer/HoverSound
@onready var click_sound = $CanvasLayer/ClickSound

# Hover scale factor
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

#
func _ready():
	# Connect back button signals
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)
	
	# Connect level_1 butoon signals
	level1_button.pressed.connect(_on_level1_pressed)
	level1_button.mouse_entered.connect(_on_level1_hover)
	level1_button.mouse_exited.connect(_on_level1_exit)
	
	# Connect level_1 butoon signals
	level2_button.pressed.connect(_on_level2_pressed)
	level2_button.mouse_entered.connect(_on_level2_hover)
	level2_button.mouse_exited.connect(_on_level2_exit)
	
	# Connect level_1 butoon signals
	level3_button.pressed.connect(_on_level3_pressed)
	level3_button.mouse_entered.connect(_on_level3_hover)
	level3_button.mouse_exited.connect(_on_level3_exit)
	
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

func click_sound_play(timeout):
	click_sound.play()
	await get_tree().create_timer(timeout).timeout
	
func _on_back_pressed():
	# Go back to Main Menu
	await click_sound_play(0.25)
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func _on_back_hover():
	if hover_sound != null: hover_sound.play()
	back_button.modulate = Color(1, 1, 0.7)
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.modulate = Color(1, 1, 1)
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
	
func _on_level1_pressed():
	# Go back to Main Menu
	#if click_sound != null: 
	Global.selected_level = 1
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")
	
func _on_level1_hover():
	if hover_sound != null: hover_sound.play()
	level1_button.modulate = Color(1, 1, 0.7)
	level1_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_level1_exit():
	level1_button.modulate = Color(1, 1, 1)
	level1_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

func _on_level2_pressed():
	# Go back to Main Menu
	Global.selected_level = 2
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")
	
func _on_level2_hover():
	if hover_sound != null: hover_sound.play()
	level2_button.modulate = Color(1, 1, 0.7)
	level2_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_level2_exit():
	level2_button.modulate = Color(1, 1, 1)
	level2_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
	
func _on_level3_pressed():
	# Go back to Main Menu
	Global.selected_level = 3
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")
	
func _on_level3_hover():
	if hover_sound != null: hover_sound.play()
	level3_button.modulate = Color(1, 1, 0.7)
	level3_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_level3_exit():
	level3_button.modulate = Color(1, 1, 1)
	level3_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
