extends CanvasLayer

export (int) var max_val
export (String) var title_texture

func update_healthbar(value):
	$MarginContainer/VBoxContainer/HBoxContainer/TextureProgress.value = value

func change_ammobar(_texture, value):
	var texture = load(_texture)
	$MarginContainer/VBoxContainer/HBoxContainer2/AmmoProgress.texture_progress = texture
	$MarginContainer/VBoxContainer/HBoxContainer2/AmmoProgress.max_value = value

func update_ammobar(value):
	$MarginContainer/VBoxContainer/HBoxContainer2/AmmoProgress.value = value
	
func update_timebar(value):
	$MarginContainer/VBoxContainer/HBoxContainer2/TimeProgress.value = value
	
func update_bossbar(value):
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.value = value
	
func start_bossbar():
	var texture = load(title_texture)
	$MarginContainer/VBoxContainer/HBoxContainer3/BossName.texture = texture
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.max_value = max_val
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.min_value = max_val/2
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.value = max_val
	
	$MarginContainer/VBoxContainer/HBoxContainer3/BossName.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.visible = true
	
func end_bossbar():
	$MarginContainer/VBoxContainer/HBoxContainer3/BossName.visible = false
	$MarginContainer/VBoxContainer/HBoxContainer4/BossProgress.visible = false