extends Node2D
class_name GameManager

# =================== GAME STATE ===================
var coins: int = 10
var current_order: String = ""
var prepared_item: String = ""
var preparing_item: bool = false
var order_timer: float = 0.0
var max_order_time: float = 60.0

var orders = ["Strawberry Pancake", "Blueberry Pancake", "Pancake", "Tea", "Coffee"]

# =================== NODE REFERENCES ===================
@onready var order_label  = get_node("../CanvasLayer/OrderLabel")
@onready var coins_label  = get_node("../CanvasLayer/CoinsLabel")
@onready var customer_node = get_node("../Customer")
@onready var order_icon = customer_node.get_node("OrderIcon") as Sprite2D
@onready var player_node   = get_node("../Player")
@onready var hotbar_icon = get_node("../CanvasLayer/HotbarSlot")

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

# =================== GAME LOOP ===================
func _ready():
	randomize()
	show_hotbar("Empty")
	spawn_new_order()
	update_ui()

func _process(delta):
	print("Timer:", order_timer)
	if current_order != "":
		order_timer -= delta
		update_ui()
		if order_timer <= 0:
			print("Order expired!")
			coins -= 2
			hide_order_icon()
			check_game_over()
			reset_order()

# =================== ORDER SPAWNING ===================
func spawn_new_order():
	if preparing_item:
		return
	var rand_index = randi() % orders.size()
	current_order = orders[rand_index]
	order_timer = max_order_time
	prepared_item = ""
	show_order_icon(current_order)
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

# =================== HOTBAR ===================
func show_hotbar(item_name: String):
	if hotbar_textures.has(item_name):
		hotbar_icon.texture = hotbar_textures[item_name]
		hotbar_icon.visible = true
	else:
		hotbar_icon.visible = false

# =================== PLAYER ACTIONS ===================
func cook_pancake():
	if preparing_item:
		return
	if current_order in ["Pancake", "Strawberry Pancake", "Blueberry Pancake"]:
		preparing_item = true
		print("Cooking pancake:", current_order)
		await get_tree().create_timer(3.0).timeout
		prepared_item = "Pancake"  # always regular pancake for stove
		preparing_item = false
		print("Pancake ready!")
		show_hotbar(prepared_item)

func start_tea():
	if preparing_item:
		return
	preparing_item = true
	print("Making Tea")
	await get_tree().create_timer(2.0).timeout
	prepared_item = "Tea"
	preparing_item = false
	print("Tea ready!")
	show_hotbar(prepared_item)

func start_coffee():
	if preparing_item:
		return
	preparing_item = true
	print("Making Coffee")
	await get_tree().create_timer(2.5).timeout
	prepared_item = "Coffee"
	preparing_item = false
	print("Coffee ready!")
	show_hotbar(prepared_item)

# =================== TOPPINGS ===================
func add_topping(topping_name: String):
	if preparing_item:
		return

	if prepared_item in ["Pancake", "Strawberry Pancake", "Blueberry Pancake"]:
		preparing_item = true
		print("Adding topping:", topping_name)
		await get_tree().create_timer(1.5).timeout  # simulate adding topping
		prepared_item = topping_name
		preparing_item = false
		print("Topping added! Now:", prepared_item)
		show_hotbar(prepared_item)  # update hotbar with new topped pancake
	else:
		print("No pancake to add topping to!")

# =================== SERVING ===================
func serve_order():
	if current_order == "":
		print("No active order!")
		return

	if prepared_item == current_order or prepared_item.begins_with(current_order):
		var coins_earned = 5
		if order_timer > max_order_time / 2:
			coins_earned += 2
		coins += coins_earned
		print("Order served successfully! Coins earned:", coins_earned)
	else:
		coins -= 3
		print("Wrong order! Coins deducted: 3")
		check_game_over()

	show_hotbar("Empty")
	hide_order_icon()
	reset_order()

func reset_order():
	prepared_item = ""
	current_order = ""
	update_ui()
	spawn_new_order()

# =================== UI ===================
func update_ui():
	coins_label.text = "Coins: " + str(coins)
	if current_order == "":
		order_label.text = "Waiting for next order..."
	else:
		var time_left = round(order_timer * 10) / 10
		order_label.text = "Customer wants: " + current_order + " (Time left: " + str(time_left) + "s)"

# =================== GAME OVER ===================
func check_game_over():
	if coins < 0:
		print("Game Over!")
		get_tree().change_scene_to_file("res://GameOver.tscn")
