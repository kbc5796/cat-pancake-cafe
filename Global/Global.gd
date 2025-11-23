extends Node

# =================== PERSISTENT GAME VARIABLES ===================
var coins: int = 300
var selected_level: int = 1
var unlocked_levels: int = 1

# =================== CAT SYSTEM ===================
var unlocked_cats: Array = ["Cat1"]   # Start with default cat
var equipped_cat: String = "Cat1"     # Default equipped cat
