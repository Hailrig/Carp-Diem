extends KinematicBody2D

signal room_entered

var door_stop = false

func _ready():
	connect("room_entered", get_parent().get_node("Fog"), "_reveal")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		_open()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		_close()

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		emit_signal('room_entered')
		get_parent().get_node("Player").current_room = "first"
		

func _open():
	if !door_stop:
		$CollisionShape2D.disabled = true
		$Sprite/AnimationPlayer.play('door_open')

func _close():
	if !door_stop:
		$CollisionShape2D.disabled = false
		$Sprite/AnimationPlayer.play('door_close')
	
func perma_open():
	$CollisionShape2D.disabled = true
	$Sprite/AnimationPlayer.play('door_open')
	door_stop=true

func save():
    var save_dict = {
		"filename" : get_filename(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"door_stop" : door_stop,
		"rotation" : rotation
    }
    return save_dict