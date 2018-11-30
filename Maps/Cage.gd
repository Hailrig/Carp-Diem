extends Node2D

signal normal_time
signal bullet_time

func makefree():
	emit_signal("bullet_time")
	$Body/AnimationPlayer.play("cage_break")
	$Free.start()

func _on_Free_timeout():
	emit_signal("normal_time")
	get_tree().change_scene("res://Maps/Outro.tscn")