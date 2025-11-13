extends Node2D

# Game variables
var score : int = 0
var level : int = 1
var orders = ["Chocolate Pancake", "Strawberry Pancake", "Blueberry Pancake"]

# UI node references
@onready var serve_button = get_node_or_null("../CanvasLayer/ServeButton")
@onready var order_label  = get_node_or_null("../CanvasLayer/OrderLabel")
@onready var score_label  = get_node_or_null("../CanvasLayer/ScoreLabel")
@onready var cat_label    = get_node_or_null("../CanvasLayer/CatLabel")

func _ready():
	randomize()  # ensure different orders each run

	# Debug: check nodes
	print("GameManager parent children:")
	for child in get_parent().get_children():
		print(child.name)

	if serve_button == null:
		print("ServeButton not found at path ../CanvasLayer/ServeButton")
	if order_label == null:
		print("OrderLabel not found at path ../CanvasLayer/OrderLabel")
	if score_label == null:
		print("ScoreLabel not found at path ../CanvasLayer/ScoreLabel")
	if cat_label == null:
		print("CatLabel not found at path ../CanvasLayer/CatLabel")

	# Connect serve button if it exists
	if serve_button != null:
		serve_button.pressed.connect(_on_serve_pressed)

	generate_new_order()
	update_ui()


# Called when "Serve Order" button is pressed
func _on_serve_pressed():
	score += 1
	check_unlocks()
	generate_new_order()
	update_ui()


# Pick a random order from the list
func generate_new_order():
	if order_label == null:
		return
	if orders.size() == 0:
		order_label.text = "No orders available!"
		return
	var rand_index = randi() % orders.size()
	order_label.text = "Customer wants: " + orders[rand_index]


# Update the score and cat level display
func update_ui():
	if score_label != null:
		score_label.text = "Score: " + str(score)
	if cat_label != null:
		cat_label.text = "Cat Chef Level: " + str(level)


# Check if the player unlocked a new cat
func check_unlocks():
	match score:
		5:
			level = 2
			if cat_label != null:
				cat_label.text = "Unlocked: Fast Chef Cat!"
		10:
			level = 3
			if cat_label != null:
				cat_label.text = "Unlocked: Patient Cat!"
		15:
			level = 4
			if cat_label != null:
				cat_label.text = "Unlocked: Lucky Cat!"
		20:
			level = 5
			if cat_label != null:
				cat_label.text = "Final Unlock: Master Chef Cat! You Win!"
			if serve_button != null:
				serve_button.disabled = true
