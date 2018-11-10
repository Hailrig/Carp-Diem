extends Node2D


func pause_game(amount):
	$PauseTimer.wait_time = amount
	$PauseTimer.start()
	get_tree().paused = true
	


func _on_PauseTimer_timeout():
	get_tree().paused = false
