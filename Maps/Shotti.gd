extends Area2D

signal get_shotti



func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("get_shotti", "shotti")
		queue_free()
