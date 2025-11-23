extends CharacterBody2D

# =================== PLAYER MOVEMENT ===================
@export var speed = 250.0

# AnimatedSprite2D nodes (make sure names match exactly)
@onready var cats = [
	$Cat1,
	$Cat2,
	$Cat3
]

var active_cat_index = 0

# Map boundaries
@export var min_x = -350
@export var max_x = 350
@export var min_y = -200
@export var max_y = 60

# =================== READY ===================
func _ready():
	# Ensure cats are hidden except the active one
	update_active_cat()
	
	# Equip the cat stored in Global
	if Global.equipped_cat != "":
		switch_cat_by_name(Global.equipped_cat)

# =================== PHYSICS / MOVEMENT ===================
func _physics_process(delta):
	var dir_vec = Vector2.ZERO
	if Input.is_action_pressed("ui_right"): dir_vec.x += 1
	if Input.is_action_pressed("ui_left"): dir_vec.x -= 1
	if Input.is_action_pressed("ui_down"): dir_vec.y += 1
	if Input.is_action_pressed("ui_up"): dir_vec.y -= 1

	dir_vec = dir_vec.normalized()
	velocity = dir_vec * speed
	move_and_slide()

	# Keep player inside boundaries
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)

	# Animate active cat
	var sprite = cats[active_cat_index]
	if dir_vec != Vector2.ZERO:
		if abs(dir_vec.x) > abs(dir_vec.y):
			sprite.animation = "right"
			sprite.flip_h = dir_vec.x < 0
		else:
			sprite.animation = "down" if dir_vec.y > 0 else "up"
			sprite.flip_h = false
		if not sprite.is_playing():
			sprite.play()
	else:
		sprite.stop()

# =================== SWITCH CAT BY INDEX ===================
func switch_cat(index: int):
	if index < 0 or index >= cats.size():
		return
	active_cat_index = index
	update_active_cat()
	# Save to Global
	Global.equipped_cat = get_active_cat_name()

# =================== SWITCH CAT BY NAME ===================
func switch_cat_by_name(cat_name: String):
	for i in range(cats.size()):
		if cats[i].name == cat_name:
			switch_cat(i)
			return
	print("Warning: Cat with name", cat_name, "not found!")

# =================== UPDATE ACTIVE CAT ===================
func update_active_cat():
	for i in range(cats.size()):
		cats[i].visible = i == active_cat_index

# =================== GET ACTIVE CAT NAME ===================
func get_active_cat_name() -> String:
	return cats[active_cat_index].name
