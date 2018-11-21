extends CanvasLayer

func update_healthbar(value):
	$MarginContainer/VBoxContainer/HBoxContainer/TextureProgress.value = value

func update_ammobar(value):
	$MarginContainer/VBoxContainer/HBoxContainer2/AmmoProgress.value = value
	
func update_timebar(value):
	$MarginContainer/VBoxContainer/HBoxContainer2/TimeProgress.value = value
	
func update_bossbar(value):
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.value = value
	
func start_bossbar():
	$MarginContainer/VBoxContainer/HBoxContainer3/BossName.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.visible = true
	
func end_bossbar():
	$MarginContainer/VBoxContainer/HBoxContainer3/BossName.visible = false
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.visible = false