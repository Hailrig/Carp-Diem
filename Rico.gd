extends "res://Weapons/EnemyBullet.gd"

signal explode

export (PackedScene) var bullet

func _ready():
	connect("explode", get_parent(), "_on_shoot")

func _explode():
	var dir = Vector2(1, 0).rotated((rotation + 3.14159))
	emit_signal("explode", bullet, $Position2D.global_position, dir)
	dir = Vector2(1, 0).rotated((rotation + 3.14159 + .5))
	emit_signal("explode", bullet, $Position2D.global_position, dir)
	dir = Vector2(1, 0).rotated((rotation + 3.14159 - .5))
	emit_signal("explode", bullet, $Position2D.global_position, dir)
	queue_free()