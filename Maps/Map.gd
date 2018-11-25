extends Node2D

var path = null
signal perma_open

func _ready():
	normal_time()
	if global.map1_door == true:
		emit_signal("perma_open")
		
#func set_camera_limits():
#	var map_limits = $TileMap.get_used_rect()
#	var map_cellsize = $TileMap.cell_size
#	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
#	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
#	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func way_back(map):
	if map == "map1":
		global.map1_door = true

func bullet_time():
	Engine.time_scale = 0.2
	self.material.set_shader_param("grayscale", true)

func normal_time():
	Engine.time_scale = 1
	self.material.set_shader_param("grayscale", false)
	
func _on_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)
	pass
	
func _clip_fly(clip, _position, animation):
	var s = clip.instance()
	add_child(s)
	s.start(_position, animation)
	pass
	
func _calculate_new_path():
	# Finds path
	var enemies = get_tree().get_nodes_in_group("enemies")
	for i in enemies:
		if i.current_room == get_node("Player").get("current_room"):
			path = $TileMap.get_path(i.position, $Player.position)
			if path:
				path.remove(0)
				i.path = path

#func save_game():
#	var save_game = File.new()
#	save_game.open("user://savegame.save", File.WRITE)
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		var node_data = i.save();
#		save_game.store_line(to_json(node_data))
#	save_game.close()

#func load_game():
#	var save_game = File.new()
#	if not save_game.file_exists("res://savegame.save"):
#		return # Error! We don't have a save to load.
#
#    # We need to revert the game state so we're not cloning objects during loading. This will vary wildly depending on the needs of a project, so take care with this step.
#    # For our example, we will accomplish this by deleting savable objects.
#	var save_nodes = get_tree().get_nodes_in_group("Persist")
#	for i in save_nodes:
#		i.queue_free()
#
#    # Load the file line by line and process that dictionary to restore the object it represents
#	save_game.open("res://savegame.save", File.READ)
#	var current_line = parse_json(save_game.get_as_text())
#        # First we need to create the object and add it to the tree and set its position.
#	var new_object = load(current_line["filename"]).instance()
#	get_node(current_line["parent"]).add_child(new_object)
#	new_object.position = Vector2(current_line["pos_x"], current_line["pos_y"])
#        # Now we set the remaining variables.
#	for i in current_line.keys():
#		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#			continue
#		new_object.set(i, current_line[i])
#	save_game.close()

