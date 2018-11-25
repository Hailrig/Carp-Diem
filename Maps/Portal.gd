extends Area2D

signal way_back

export (String) var target
export (Vector2) var spawn_point


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		emit_signal("way_back", "map1")
		get_tree().change_scene(target)
		print('hi')
		if spawn_point:
			global.player_pos = spawn_point