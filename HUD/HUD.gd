extends CanvasLayer

func update_healthbar(value):
	$MarginContainer/VBoxContainer/HBoxContainer/TextureProgress.value = value

func update_ammobar(value):
	$MarginContainer/VBoxContainer/HBoxContainer2/AmmoProgress.value = value

func health_changed():
	pass # replace with function body
