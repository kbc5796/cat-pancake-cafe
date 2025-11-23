extends Node2D

# ================== BUTTONS ==================
@onready var level1_button = $CanvasLayer/LevelOne
@onready var level2_button = $CanvasLayer/LevelTwo
@onready var level3_button = $CanvasLayer/LevelThree
@onready var back_button = $CanvasLayer/Back
@onready var howtoplay_button = $CanvasLayer/HowToPlay
@onready var shop_button = $CanvasLayer/Shop  

# ================== SOUNDS ==================
@onready var hover_sound = $CanvasLayer/HoverSound
@onready var click_sound = $CanvasLayer/ClickSound

# ================== BUTTON SCALE ==================
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

# ================== READY ==================
func _ready():
	update_level_buttons()

	# Connect buttons
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)

	level1_button.pressed.connect(_on_level1_pressed)
	level1_button.mouse_entered.connect(_on_level1_hover)
	level1_button.mouse_exited.connect(_on_level1_exit)

	level2_button.pressed.connect(_on_level2_pressed)
	level2_button.mouse_entered.connect(_on_level2_hover)
	level2_button.mouse_exited.connect(_on_level2_exit)

	level3_button.pressed.connect(_on_level3_pressed)
	level3_button.mouse_entered.connect(_on_level3_hover)
	level3_button.mouse_exited.connect(_on_level3_exit)

	howtoplay_button.pressed.connect(_on_howtoplay_pressed)
	howtoplay_button.mouse_entered.connect(_on_howtoplay_hover)
	howtoplay_button.mouse_exited.connect(_on_howtoplay_exit)

	shop_button.pressed.connect(_on_shop_pressed)
	shop_button.mouse_entered.connect(_on_shop_hover)
	shop_button.mouse_exited.connect(_on_shop_exit)

# ================== LEVEL BUTTON LOGIC ==================
func update_level_buttons():
	level1_button.disabled = false
	
	level2_button.disabled = Global.unlocked_levels < 2
	level2_button.modulate = Color(1,1,1) if not level2_button.disabled else Color(0.5,0.5,0.5)

	level3_button.disabled = Global.unlocked_levels < 3
	level3_button.modulate = Color(1,1,1) if not level3_button.disabled else Color(0.5,0.5,0.5)

# ================== HELPER ==================
func click_sound_play(timeout):
	click_sound.play()
	await get_tree().create_timer(timeout).timeout

# ================== BUTTON FUNCTIONS ==================

# ----- Back button -----
func _on_back_pressed():
	await click_sound_play(0.25)
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_back_hover():
	if hover_sound != null: hover_sound.play()
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

# ----- Level buttons -----
func _on_level1_pressed():
	Global.selected_level = 1
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")

func _on_level2_pressed():
	Global.selected_level = 2
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")

func _on_level3_pressed():
	Global.selected_level = 3
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://MainGame.tscn")

func _on_level1_hover():
	if hover_sound != null: hover_sound.play()
	level1_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)
func _on_level1_exit(): level1_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

func _on_level2_hover():
	if hover_sound != null: hover_sound.play()
	level2_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)
func _on_level2_exit(): level2_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

func _on_level3_hover():
	if hover_sound != null: hover_sound.play()
	level3_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)
func _on_level3_exit(): level3_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

# ----- HowToPlay button -----
func _on_howtoplay_pressed():
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://how_to_play.tscn")

func _on_howtoplay_hover():
	if hover_sound != null: hover_sound.play()
	howtoplay_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_howtoplay_exit():
	howtoplay_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

# ----- Shop button -----
func _on_shop_pressed():
	await click_sound_play(0.1)
	get_tree().change_scene_to_file("res://shop.tscn") 

func _on_shop_hover():
	if hover_sound != null: hover_sound.play()
	shop_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_shop_exit():
	shop_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)
