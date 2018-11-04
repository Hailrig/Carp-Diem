extends Navigation2D

func update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Navigation2D class
	# it returns a PoolVector2Array of points that lead you from the
	# start_position to the end_position
	print(start_position)
	print (end_position)
	path = $Navigation2D.get_simple_path(start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove(0)
	set_process(true)