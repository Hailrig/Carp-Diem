extends KinematicBody2D

signal room_entered

var door_stop

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
