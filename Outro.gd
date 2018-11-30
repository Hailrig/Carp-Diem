extends RichTextLabel

var dialog = "Kidnapping, eh? Just goes to show that you open one can of tuna and two more show up, also waiting to be opened. An unending supply of tuna. I can't make out what they planned to do with the victims, but I know there's more up the tower. I don't know what I'll find for sure, but what I do know is that something smells fishy."
var dialog2

func _ready():
	bbcode_text = dialog
	visible_characters = 0
	$AudioStreamPlayer.play()

func _on_LetterCounter_timeout():
	visible_characters += 1
	if visible_characters == 323:
		$AudioStreamPlayer.stop()
		$ReadTime.start()

func _on_ReadTime_timeout():
	visible = false
	get_parent().get_node("Sprite2").visible = true
	$KillTime.start()

func _on_KillTime_timeout():
	get_tree().quit()
