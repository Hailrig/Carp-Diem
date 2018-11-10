extends Node2D

func _ready():
	normal_time()
#func set_camera_limits():
#	var map_limits = $TileMap.get_used_rect()
#	var map_cellsize = $TileMap.cell_size
#	$Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
#	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
#	$Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
#	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

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
	
func _calculate_new_path():
	# Finds path
		var enemies = get_tree().get_nodes_in_group("enemies")
		for i in enemies:
			var path = $TileMap.get_path(i.position, $Player.position)

	# If we got a path...
			if path:

		# Remove the first point (it's where the sidekick is)
				path.remove(0)

		# Sets the sidekick's path
				i.path = path
