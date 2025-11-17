extends CharacterBody2D

@export var speed = 200.0
@onready var sprite = $Sprite2D

# Four direction textures
@onready var tex_up    = load("res://Sprites/player_up.png")
@onready var tex_down  = load("res://Sprites/player_down.png")
@onready var tex_left  = load("res://Sprites/player_left.png")
@onready var tex_right = load("res://Sprites/player_right.png")

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	# Flip sprite if moving left/right
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
		
	
