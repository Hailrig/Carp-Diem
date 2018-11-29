extends RichTextLabel

var dialog = "I'm a drifter, always on the move. Can't stay in the same town for too long; it suffocates me. That's the problem with ram ventilation, I can't stay tied down for long. Next town I came across was nothing but empty streets with a looming tower in the distance. Something smelled fishy, and I was going to investigate"

func _ready():
	bbcode_text = dialog
	visible_characters = 0
	$AudioStreamPlayer.play()

func _on_LetterCounter_timeout():
	visible_characters += 1
	if visible_characters == 323:
		$ReadMe.start()
		$AudioStreamPlayer.stop()

func _on_ReadMe_timeout():
	get_tree().change_scene("res://Maps/Testmap.tscn")