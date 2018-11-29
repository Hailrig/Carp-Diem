extends Area2D

signal get_auto



func _on_Auto_body_entered(body):
	if body.name == "Player":
		emit_signal("get_auto", "auto")
		queue_free()
