extends Area2D

@export var machine_type = "Stove"
var player_in_area = false
var game_manager

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	game_manager = get_node("/root/MainGame/GameManager")  

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		print("Player in range of Stove")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		print("Player left Stove")

func _process(_delta):
	# Player taps/clicks stove
	if player_in_area and Input.is_action_just_pressed("ui_accept"):
		print("Stove interaction detected!")
		print("Using Stove")
		if game_manager != null:
			game_manager.cook_pancake()  
