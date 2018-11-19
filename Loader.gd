extends Node

#func _ready():
	#load_game()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		return # Error! We don't have a save to load.

    # We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
    # For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.get_parent().remove_child(i)
		i.queue_free()

    # Load the file line by line and process that dictionary to restore the object it represents
	save_game.open("res://savegame.save", File.READ)
	for i in 2:
		var current_line = parse_json(save_game.get_line())
        # First we need to create the object and add it to the tree and set its position.
		var new_object = load(current_line["filename"]).instance()
		get_node(current_line["parent"]).add_child(new_object)
	
		new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
		new_object.scale = Vector2(current_line["scale_x"], current_line["scale_y"])
        # Now we set the remaining variables.
		for i in current_line.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "scale_x" or i == "scale_y":
				continue
			new_object.set(i, current_line[i])
		new_object.add_to_group("Persist")
	save_game.close()
	
	
#	var con_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in con_nodes:
#		i.connecter()