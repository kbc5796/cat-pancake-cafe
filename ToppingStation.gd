extends Area2D

@export var machine_type: String = "ToppingStation"

# ======== NODES ========
@onready var topping_menu = get_node_or_null("../CanvasLayer/ToppingMenu")
@onready var strawberry_button = get_node_or_null("../CanvasLayer/ToppingMenu/StrawberryButton")
@onready var blueberry_button = get_node_or_null("../CanvasLayer/ToppingMenu/BlueberryButton")
@onready var game_manager = get_node_or_null("/root/MainGame/GameManager")

var player_in_area = false

# ======== READY ========
func _ready():
	if topping_menu != null:
		topping_menu.visible = false

	if strawberry_button != null:
		strawberry_button.pressed.connect(_on_strawberry_pressed)
	if blueberry_button != null:
		blueberry_button.pressed.connect(_on_blueberry_pressed)

	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

# ======== AREA2D SIGNALS ========
func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		print("Player in range of ToppingStation")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		print("Player left ToppingStation")

# ======== CLICK DETECTION ========
func _input_event(viewport, event, shape_idx):
	if player_in_area and event.is_action_pressed("ui_accept"):
		if topping_menu != null:
			topping_menu.visible = true
			topping_menu.grab_focus()

# ======== BUTTON CALLBACKS ========
func _on_strawberry_pressed():
	if topping_menu != null:
		topping_menu.visible = false
	if game_manager != null:
		game_manager.add_topping("Strawberry Pancake")

func _on_blueberry_pressed():
	if topping_menu != null:
		topping_menu.visible = false
	if game_manager != null:
		game_manager.add_topping("Blueberry Pancake")
