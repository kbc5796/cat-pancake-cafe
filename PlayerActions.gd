extends CharacterBody2D

@export var speed = 250.0
@onready var sprite = $Sprite2D
@onready var tex_up    = load("res://Sprites/player_up.png")
@onready var tex_down  = load("res://Sprites/player_down.png")
@onready var tex_left  = load("res://Sprites/player_left.png")
@onready var tex_right = load("res://Sprites/player_right.png")

var min_x = -350
var max_x = 350
var min_y = -200
var max_y = 60

func _physics_process(_delta):
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

	## Flip sprite if moving left/right
	#if direction.x > 0:
		#sprite.flip_h = false
	#elif direction.x < 0:
		#sprite.flip_h = true
	## Change sprite if moving
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprite.texture = tex_right
			else:
				sprite.texture = tex_left
		else:
			if direction.y > 0:
				sprite.texture = tex_down
			else:
				sprite.texture = tex_up
	# Clamp player position to map boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
