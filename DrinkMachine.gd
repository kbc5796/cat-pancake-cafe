extends Area2D

@export var machine_type: String = "DrinkMachine"

# ======== NODES ========
@onready var drink_menu = get_node_or_null("../CanvasLayer/DrinkMenu")
@onready var tea_button = get_node_or_null("../CanvasLayer/DrinkMenu/TeaButton")
@onready var coffee_button = get_node_or_null("../CanvasLayer/DrinkMenu/CoffeeButton")
@onready var game_manager = get_node_or_null("/root/MainGame/GameManager")

var player_in_area = false

# ======== READY ========
func _ready():
	if drink_menu != null:
		drink_menu.visible = false

	if tea_button != null:
		tea_button.pressed.connect(_on_tea_button_pressed)
	if coffee_button != null:
		coffee_button.pressed.connect(_on_coffee_button_pressed)

	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

# ======== AREA2D SIGNALS ========
func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		print("Player in range of DrinkMachine")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		print("Player left DrinkMachine")

# ======== CLICK DETECTION ========
func _input_event(viewport, event, shape_idx):
	if player_in_area and event.is_action_pressed("ui_accept"):
		if drink_menu != null:
			drink_menu.visible = true
			drink_menu.grab_focus()

# ======== BUTTON CALLBACKS ========
func _on_tea_button_pressed():
	if drink_menu != null:
		drink_menu.visible = false
	if game_manager != null:
		game_manager.start_tea()

func _on_coffee_button_pressed():
	if drink_menu != null:
		drink_menu.visible = false
	if game_manager != null:
		game_manager.start_coffee()
