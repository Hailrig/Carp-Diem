extends Node

func _ready():
	load_game()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

    # We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
    # For our example, we will accomplish this by deleting savable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

    # Load the file line by line and process that dictionary to restore the object it represents
	save_game.open("user://savegame.save", File.READ)
	var current_line = parse_json(save_game.get_as_text())
        # First we need to create the object and add it to the tree and set its position.
	var new_object = load(current_line["filename"]).instance()
	get_node(current_line["parent"]).add_child(new_object)
	new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
	new_object.name = current_line["name"]
        # Now we set the remaining variables.
	for i in current_line.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "name":
			continue
		new_object.set(i, current_line[i])
	save_game.close()