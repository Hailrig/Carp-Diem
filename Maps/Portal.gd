extends Area2D

signal way_back

export (String) var target
export (Vector2) var spawn_point
export (String) var map


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("way_back", map)
		get_tree().change_scene(target)
		if spawn_point:
			global.player_pos = spawn_point