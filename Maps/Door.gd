extends KinematicBody2D

signal room_entered

export (String) var room

var door_stop = false

#func _ready():
#	connecter()

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
	if !door_stop:
		$CollisionShape2D.disabled = true
		$Sprite/AnimationPlayer.play('door_open')
		$AudioStreamPlayer2D.play()

func _close():
	if !door_stop:
		$CollisionShape2D.disabled = false
		$Sprite/AnimationPlayer.play('door_close')
		$AudioStreamPlayer2D.play()
	
func perma_open():
	$CollisionShape2D.disabled = true
	$Sprite/AnimationPlayer.play('door_open')
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
