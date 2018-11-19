extends Area2D

signal room_clear

export (String) var room

var enemies_array = []
var room_clear = false

#func _ready():
#	connecter()

func _process(delta):
	if room_clear == false:
		enemies_array.clear()
		var enemies_in_room = get_tree().get_nodes_in_group(room)
		for i in enemies_in_room:
			enemies_array.append(i)
		if enemies_array.empty():
			emit_signal("room_clear")
			room_clear = true

func _reveal():
	visible = false
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"room" : room,
		"visible" : visible,
	}
	return save_dict

#func connecter():
#	connect("room_clear", get_parent().get_node("Door"), "perma_open")
#	print(name)