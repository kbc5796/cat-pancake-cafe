extends Node2D
class_name GameManager

# =================== BUTTONS ===================
@onready var back_button = get_node("../CanvasLayer/Back")

# =================== SOUNDS ===================
@onready var hover_sound = get_node("../CanvasLayer/HoverSound")
@onready var click_sound = get_node("../CanvasLayer/ClickSound")
@onready var interact_sound = get_node("../CanvasLayer/InteractiveSound")
@onready var ding_sound = get_node("../CanvasLayer/Ding")
@onready var countdown_sound = get_node("../CanvasLayer/CountDown")
@onready var bell_sound = get_node("../CanvasLayer/Bell")
@onready var fire_sound = get_node("../CanvasLayer/Fire")
@onready var drink_sound = get_node("../CanvasLayer/Drink")

# Hover scale factor
const HOVER_SCALE = 0.30
const NORMAL_SCALE = 0.25

# =================== GAME STATE ===================
var current_order: String = ""
var prepared_item: String = ""
var preparing_item: bool = false
var order_timer: float = 0.0
var max_order_time: float = 60.0
var random_size = 3
var round_timer = 90.0
var played_countdown_sound = false
var game_is_over = false
var level1_index = 2

# Orders
var orders = ["Tea", "Coffee", "Pancake", "Strawberry Pancake", "Blueberry Pancake"]

# Track level completion
var orders_served: int = 0
var orders_to_complete_level: int = 10  # updated per level

# =================== NODE REFERENCES ===================
@onready var order_label  = get_node("../CanvasLayer/OrderLabel")
@onready var coins_label  = get_node("../CanvasLayer/CoinsLabel")
@onready var timer_label  = get_node("../CanvasLayer/TimerLabel")
@onready var customer_node = get_node("../Customer")
@onready var order_icon = customer_node.get_node("OrderIcon") as Sprite2D
@onready var player_node   = get_node("../Player")
@onready var hotbar_icon = get_node("../CanvasLayer/HotbarSlot")
@onready var customer_sprite = customer_node.get_node("Sprite2D")

# =================== HOTBAR TEXTURES ===================
var hotbar_textures = {
	"Empty": load("res://Hotbar/EmptyHotBar.png"),
	"Pancake": load("res://Hotbar/PancakeHotBar.png"),
	"Strawberry Pancake": load("res://Hotbar/StrawberryHotBar.png"),
	"Blueberry Pancake": load("res://Hotbar/BlueberryHotBar.png"),
	"Tea": load("res://Hotbar/TeaHotBar.png"),
	"Coffee": load("res://Hotbar/CoffeeHotBar.png")
}

var order_textures = {
	"Tea": load("res://Orders/Tea.png"),
	"Coffee": load("res://Orders/Coffee.png"),
	"Pancake": load("res://Orders/Pancake.png"),
	"Strawberry Pancake": load("res://Orders/StrawberryPancake.png"),
	"Blueberry Pancake": load("res://Orders/BlueberryPancake.png")
}

var customer_textures = [
	load("res://Sprites/customer.png"),
	load("res://Sprites/customer2.png"),
	load("res://Sprites/customer3.png"),
	load("res://Sprites/customer4.png")
]

# =================== CAT SHOP PRICES ===================
var cat_prices = {
	"Cat1": 0,
	"Cat2": 15,
	"Cat3": 25
}

# =================== MUSIC FUNCTIONS ===================
func click_sound_play(timeout):
	if click_sound != null:
		click_sound.play()
	await get_tree().create_timer(timeout).timeout

func interact_sound_play(timeout):
	if interact_sound != null:
		interact_sound.play()
	await get_tree().create_timer(timeout).timeout

func ding_sound_play():
	if bell_sound != null:
		bell_sound.stop()
	if ding_sound != null:
		ding_sound.play()

# =================== BUTTON FUNCTIONS ===================
func _on_back_pressed():
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
	back_button.pressed.connect(_on_back_pressed)
	back_button.mouse_entered.connect(_on_back_hover)
	back_button.mouse_exited.connect(_on_back_exit)

# =================== GAME LOOP ===================
func _ready():
	MusicPlayer.play_shop()
	connect_button()
	randomize()
	show_hotbar("Empty")
	await init_level()
	await waiting_order()
	spawn_new_order()
	update_ui()
	player_node.switch_cat_by_name(Global.equipped_cat)

	# Endless mode disables timer
	if Global.selected_level == 0:
		round_timer = INF

func _process(delta):
	# Only count down timer for normal levels
	if Global.selected_level != 0:
		round_timer -= delta
		if(round_timer <= 0): check_game_over()
		if(round_timer <= 10.1 && !played_countdown_sound):
			if countdown_sound != null:
				countdown_sound.play()
			played_countdown_sound = true
		
	update_ui()
	if current_order != "":
		order_timer -= delta
		update_ui()
		if order_timer <= 0:
			print("Order expired!")
			Global.coins -= 4
			hide_order_icon()
			if Global.selected_level != 0:  # Check game over only in normal levels
				if !check_game_over(): 
					reset_order()
			else:  # Endless: just reset
				reset_order()

# =================== LEVEL SETTING ===================
func init_level():
	orders_served = 0
	if(Global.selected_level == 1): 
		random_size = 3
		max_order_time = 60.0
		orders_to_complete_level = 2
	elif(Global.selected_level == 2):
		random_size = 5
		max_order_time = 30.0
		orders_to_complete_level = 4
	elif(Global.selected_level == 3): 
		random_size = 5
		max_order_time = 15.0
		orders_to_complete_level = 6
	elif(Global.selected_level == 0): # Endless
		random_size = 5
		max_order_time = 30.0  # optional, could make each order same time
		orders_to_complete_level = INF  # Endless never completes

# =================== ORDER SPAWNING ===================
func spawn_new_order():
	var rand_index = randi() % random_size
	
	if(Global.selected_level == 3 && rand_index <= 2):
		var rand_num = randi() % 3
		if(rand_num % 2 == 1):
			if(rand_index <= 2): rand_index += 2
	
	if Global.selected_level == 1:
		rand_index = level1_index
		level1_index += 1
		level1_index %= 3
		
	current_order = orders[rand_index]
	order_timer = max_order_time
	show_order_icon(current_order)
	ding_sound_play()
	update_ui()
	print("New order spawned:", current_order)

func show_order_icon(order_name: String):
	if order_textures.has(order_name):
		order_icon.texture = order_textures[order_name]
		order_icon.visible = true
	else:
		order_icon.visible = false

func hide_order_icon():
	order_icon.visible = false

func hide_customer():
	customer_node.visible = false

func show_customer():
	var random_index = randi() % customer_textures.size()
	customer_sprite.texture = customer_textures[random_index]
	customer_node.visible = true

func waiting_order():
	hide_customer()
	var rand_time = randi() % 2 + 2
	current_order = ""
	update_ui()
	await get_tree().create_timer(rand_time).timeout
	show_customer()

# =================== HOTBAR ===================
func show_hotbar(item_name: String):
	if hotbar_textures.has(item_name):
		hotbar_icon.texture = hotbar_textures[item_name]
		hotbar_icon.visible = true
		if(item_name != "Empty" and bell_sound != null): bell_sound.play()
	else:
		hotbar_icon.visible = false

# =================== PLAYER ACTIONS ===================
func cook_pancake():
	if preparing_item: return
	preparing_item = true
	if fire_sound != null: fire_sound.play()
	await get_tree().create_timer(3.0).timeout
	prepared_item = "Pancake"
	preparing_item = false
	if fire_sound != null: fire_sound.stop()
	show_hotbar(prepared_item)

func start_tea():
	if preparing_item: return
	if drink_sound != null: drink_sound.play()
	preparing_item = true
	await get_tree().create_timer(2.0).timeout
	if drink_sound != null: drink_sound.stop()
	prepared_item = "Tea"
	preparing_item = false
	show_hotbar(prepared_item)

func start_coffee():
	if preparing_item: return
	if drink_sound != null: drink_sound.play()
	preparing_item = true
	await get_tree().create_timer(2.5).timeout
	if drink_sound != null: drink_sound.stop()
	prepared_item = "Coffee"
	preparing_item = false
	show_hotbar(prepared_item)

# =================== TOPPINGS ===================
func add_topping(topping_name: String):
	if preparing_item: return
	if prepared_item in ["Pancake", "Strawberry Pancake", "Blueberry Pancake"]:
		preparing_item = true
		prepared_item = ""
		await get_tree().create_timer(1.5).timeout
		prepared_item = topping_name
		preparing_item = false
		show_hotbar(prepared_item)

# =================== SERVING ===================
func serve_order():
	if current_order == "": return

	if prepared_item == current_order or prepared_item.begins_with(current_order):
		var coins_earned = 5
		if order_timer > max_order_time / (Global.selected_level + 1):
			coins_earned += 2
		Global.coins += coins_earned
		prepared_item = ""
		orders_served += 1
	else:
		Global.coins -= 5
		prepared_item = ""
		if Global.selected_level != 0:  # check game over only in normal levels
			if await check_game_over(): return

	show_hotbar("Empty")
	hide_order_icon()
	if Global.selected_level != 0:
		check_level_completion()
	reset_order()

func reset_order():
	current_order = ""
	await ding_sound_play()
	await waiting_order()
	spawn_new_order()

# =================== UI ===================
func update_ui():
	coins_label.text = str(Global.coins)
	if Global.selected_level != 0:
		timer_label.text = str(max(0, round(round_timer * 10) / 10))
	else:
		timer_label.text = "∞"  # Endless mode
	if current_order == "":
		order_label.text = "Waiting for next order..."
	else:
		var time_left = round(order_timer * 10) / 10
		order_label.text = "Customer wants: " + current_order + " (Time left: " + str(time_left) + "s)"

# =================== LEVEL COMPLETION ===================
func check_level_completion():
	if Global.selected_level == 0:
		return  # Endless never completes
	if orders_served >= orders_to_complete_level:
		match Global.selected_level:
			1: Global.unlocked_levels = 2
			2: Global.unlocked_levels = 3
			3: end_game("res://YouWin.tscn")
		if Global.selected_level != 3:
			end_game("res://LevelCompletion.tscn")

# =================== GAME OVER ===================
func end_game(path):
	game_is_over = true
	back_button.visible = false
	order_label.visible = false
	hotbar_icon.visible = false
	Transition.fade_to_scene(path)

func check_game_over():
	if game_is_over: return true
	if round_timer <= 0 or Global.coins < 0:
		end_game("res://GameOver.tscn")
		return true
	return false

# =================== SHOP FUNCTIONS (for external shop scene) ===================
func buy_cat(cat_name: String):
	var price = cat_prices.get(cat_name, 999)
	if Global.coins >= price:
		Global.coins -= price
		if cat_name not in Global.unlocked_cats:
			Global.unlocked_cats.append(cat_name)
		equip_cat(cat_name)
	else:
		print("Not enough coins to buy", cat_name)
	update_ui()

func equip_cat(cat_name: String):
	if cat_name in Global.unlocked_cats:
		player_node.switch_cat_by_name(cat_name)
		Global.equipped_cat = cat_name
		print("Equipped cat:", cat_name)
