extends Node2D

@onready var btn = $CanvasLayer/Button

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if btn == null:
		print("Button not found!")  # This helps debug
	else:
		print("Button found:", btn)
		btn.pressed.connect(_on_pressed)

func _on_pressed():
	print("Button clicked!")
