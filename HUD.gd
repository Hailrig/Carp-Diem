extends CanvasLayer

func update_healthbar(value):
	$MarginContainer/HBoxContainer/TextureProgress.value = value

func health_changed():
	pass # replace with function body
