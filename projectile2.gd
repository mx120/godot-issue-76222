extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var projectile_class = load("res://projectile1.gd")
	var projectile = projectile_class.new(600, 20, 1000, get_global_mouse_position(), self)




