extends "res://Characters/Characters.gd"

export (int) var detect_radius

var target = null

func _ready():
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	
func _process(delta):
	if target:
		var target_dir = (target.global_position - global_position).normalized()
		var current_dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		$Weapon.global_rotation = target_dir.angle()
		shoot()
	


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		target = body


func _on_Area2D_body_exited(body):
	if body ==  target:
		target = null
