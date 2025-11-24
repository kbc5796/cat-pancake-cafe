extends Node2D

# ================== BUTTONS ==================
@onready var cat1_button = $CanvasLayer/Cat1
@onready var cat2_button = $CanvasLayer/Cat2
@onready var cat3_button = $CanvasLayer/Cat3
@onready var back_button = $CanvasLayer/Back

@onready var coins_label = $CanvasLayer/CoinsLabel

# ================== SOUNDS ==================
@onready var hover_sound = $CanvasLayer/HoverSound
@onready var click_sound = $CanvasLayer/ClickSound

# ================== HOVER SCALE ==================
const HOVER_SCALE = 1.1
const NORMAL_SCALE = 1.0

# ================== CAT COSTS ==================
var cat_costs = {
	"Cat1": 0,
	"Cat2": 100,
	"Cat3": 200
}

# ================== READY ==================
func _ready():
	MusicPlayer.play_shop()
	update_coins_label()
	connect_buttons()
	update_button_highlight()

# ================== HELPER ==================
func click_sound_play(timeout: float = 0.1) -> void:
	if click_sound != null:
		click_sound.play()
	await get_tree().create_timer(timeout).timeout

func connect_buttons():
	# Back button
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)

	# Cat buttons
	cat1_button.pressed.connect(_on_cat_pressed.bind("Cat1"))
	cat1_button.mouse_entered.connect(_on_hover.bind(cat1_button))
	cat1_button.mouse_exited.connect(_on_exit.bind(cat1_button))

	cat2_button.pressed.connect(_on_cat_pressed.bind("Cat2"))
	cat2_button.mouse_entered.connect(_on_hover.bind(cat2_button))
	cat2_button.mouse_exited.connect(_on_exit.bind(cat2_button))

	cat3_button.pressed.connect(_on_cat_pressed.bind("Cat3"))
	cat3_button.mouse_entered.connect(_on_hover.bind(cat3_button))
	cat3_button.mouse_exited.connect(_on_exit.bind(cat3_button))

# ================== BUTTON FUNCTIONS ==================
func _on_back_pressed():
	MusicPlayer.play_main()
	await click_sound_play(0.1)  
	get_tree().change_scene_to_file("res://LevelSelect.tscn")

func _on_back_hover():
	if hover_sound != null: hover_sound.play()
	back_button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_back_exit():
	back_button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

func _on_hover(button: Button):
	if hover_sound != null: hover_sound.play()
	button.scale = Vector2(HOVER_SCALE, HOVER_SCALE)

func _on_exit(button: Button):
	button.scale = Vector2(NORMAL_SCALE, NORMAL_SCALE)

# ================== CAT BUTTONS ==================
func _on_cat_pressed(cat_name: String):
	var player = get_tree().get_root().get_node("MainGame/Player")

	# Already owned
	if cat_name in Global.unlocked_cats:
		print("You already own", cat_name)
		# Equip it immediately
		Global.equipped_cat = cat_name
		if player != null:
			player.switch_cat_by_name(cat_name)
		update_button_highlight()
		return

	# Attempt purchase
	var cost = cat_costs[cat_name]
	if Global.coins >= cost:
		Global.coins -= cost
		Global.unlocked_cats.append(cat_name)
		Global.equipped_cat = cat_name  # Equip immediately
		if player != null:
			player.switch_cat_by_name(cat_name)
		print(cat_name, "purchased and equipped! Coins left:", Global.coins)
		update_coins_label()
		update_button_highlight()
	else:
		print("Not enough coins to buy", cat_name)

# ================== UI ==================
func update_coins_label():
	if coins_label != null:
		coins_label.text = "Coins: " + str(Global.coins)

func update_button_highlight():
	# Visual indicator of equipped cat
	for btn_name in ["Cat1", "Cat2", "Cat3"]:
		var btn = $CanvasLayer.get_node(btn_name.to_lower())
		if btn != null:
			if btn_name == Global.equipped_cat:
				btn.modulate = Color(0.7, 1, 0.7) # Highlight green
			else:
				btn.modulate = Color(1,1,1)
