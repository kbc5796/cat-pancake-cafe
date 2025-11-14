extends Area2D

var player_in_area = false
var game_manager

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	game_manager = get_node("/root/MainGame/GameManager") 

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true
		print("Player at customer!")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false
		print("Player left customer!")

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("ui_accept"):
		if game_manager != null:
			print("Serving customer")
			game_manager.serve_order()
