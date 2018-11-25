extends Area2D

signal get_key

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("get_key")
		queue_free()
