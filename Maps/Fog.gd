extends Area2D

signal room_clear

export (String) var room

var enemies_array = []

func _process(delta):
	enemies_array.clear()
	var enemies_in_room = get_tree().get_nodes_in_group(room)
	for i in enemies_in_room:
		enemies_array.append(i)
	if enemies_array.empty():
		emit_signal('room_clear')
		queue_free()

func _reveal():
	visible = false