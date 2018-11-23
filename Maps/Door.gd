extends KinematicBody2D

signal room_entered

export (String) var room
export (bool) var locked
export (int) var keys
export (bool) var enemyless
export (String) var enter_dir
export (bool) var z_change

export (String) var open_behind
export (String) var open_front
export (String) var close_behind
export (String) var close_front

var door_stop = false

func _ready():
	if enter_dir == "east":
		$Area2D/CollisionShape2D.position.x = -9.74668
		$Area2D/CollisionShape2D.position.y = 0.86022
		$Area2D/CollisionShape2D.scale.x = 1
		$Area2D/CollisionShape2D.scale.y = 1.67219
		
		$Area2D2/CollisionShape2D.position.x = 42.113918
		$Area2D2/CollisionShape2D.position.y = -1.58433
		$Area2D2/CollisionShape2D.scale.x = 1
		$Area2D2/CollisionShape2D.scale.y = 1.67219
		
		$CollisionShape2D.position.x = 0
		$CollisionShape2D.position.y = 0
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1
	if enter_dir == "west":
		$Area2D/CollisionShape2D.position.x = 47.693378
		$Area2D/CollisionShape2D.position.y = -0.891688
		$Area2D/CollisionShape2D.scale.x = 1
		$Area2D/CollisionShape2D.scale.y = 1.67219
		
		$Area2D2/CollisionShape2D.position.x = -16.858112
		$Area2D2/CollisionShape2D.position.y = -1.58433
		$Area2D2/CollisionShape2D.scale.x = 1
		$Area2D2/CollisionShape2D.scale.y = 1.67219
		
		$CollisionShape2D.position.x = 26.570557
		$CollisionShape2D.position.y = 0
		$CollisionShape2D.scale.x = 1
		$CollisionShape2D.scale.y = 1
	if enter_dir == "north":
		$Area2D/CollisionShape2D.position.x = 36.423717
		$Area2D/CollisionShape2D.position.y = 27.738504
		$Area2D/CollisionShape2D.scale.x = 0.1
		$Area2D/CollisionShape2D.scale.y = 12
		
		$Area2D2/CollisionShape2D.position.x = 25.980251
		$Area2D2/CollisionShape2D.position.y = -40.504257
		$Area2D2/CollisionShape2D.scale.x = 12
		$Area2D2/CollisionShape2D.scale.y = 0.1
		
		$CollisionShape2D.position.x = 29.965691
		$CollisionShape2D.position.y = 12.128963
		$CollisionShape2D.scale.x = 12
		$CollisionShape2D.scale.y = 0.05
		
		$FrontDoor.visible = false
	if enter_dir == "south":
		$Area2D/CollisionShape2D.position.x = 36.423717
		$Area2D/CollisionShape2D.position.y = -33.144161
		$Area2D/CollisionShape2D.scale.x = 0.2
		$Area2D/CollisionShape2D.scale.y = 12
		
		$Area2D2/CollisionShape2D.position.x = 25.980251
		$Area2D2/CollisionShape2D.position.y = 23.558338
		$Area2D2/CollisionShape2D.scale.x = 12
		$Area2D2/CollisionShape2D.scale.y = 0.1
		
		$CollisionShape2D.position.x = 29.965691
		$CollisionShape2D.position.y = -18.164143
		$CollisionShape2D.scale.x = 12
		$CollisionShape2D.scale.y = 0.05
		
		$FrontDoor.visible = false
	
	if z_change:
		$BehindDoor.z_index = 5
	
	$BehindDoor/AnimationPlayer.play(close_behind)
	$FrontDoor/AnimationPlayer.play(close_front)

func unlock():
	keys -= 1
	if keys <= 0:
		locked = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		_open()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		_close()

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		emit_signal('room_entered')
		get_parent().get_node("Player").current_room = room
		

func _open():
	if !door_stop and !locked and enemyless:
		emit_signal('room_entered')
		perma_open()
	elif !door_stop and !locked:
		print("fuckyou")
		$CollisionShape2D.disabled = true
		$BehindDoor/AnimationPlayer.play(open_behind)
		$FrontDoor/AnimationPlayer.play(open_front)
		$AudioStreamPlayer2D.play()

func _close():
	if !door_stop and !locked:
		print("fuckme")
		$CollisionShape2D.disabled = false
		$BehindDoor/AnimationPlayer.play(close_behind)
		$FrontDoor/AnimationPlayer.play(close_front)
		$AudioStreamPlayer2D.play()
	
func perma_open():
	$CollisionShape2D.disabled = true
	$BehindDoor/AnimationPlayer.play(open_behind)
	$FrontDoor/AnimationPlayer.play(open_front)
	door_stop=true
	$AudioStreamPlayer2D.play()
	$Area2D.queue_free()
	$Area2D2.queue_free()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"door_stop" : door_stop,
		"rotation" : rotation
	}
	return save_dict
#
#func connecter():
#	connect("room_entered", get_parent().get_node("Fog"), "_reveal")
#	print(name)

func _reveal():
	pass # replace with function body
