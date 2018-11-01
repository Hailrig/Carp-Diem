extends "res://Characters/Characters.gd"

var direction


func control(delta):
	$Weapon.look_at(get_global_mouse_position())
	velocity = Vector2()
	if Input.is_action_pressed('move_up'):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed('move_down'):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed('move_left'):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed('move_right'):
		velocity += Vector2(1, 0)
	
	if Input.is_action_just_pressed('dash') and $RollCooldown.is_stopped():
		set_collision_layer_bit(4, true)
		set_collision_layer_bit(1, false)
		
		$RollTime.start()
		$RollCooldown.start()
	if $RollTime.time_left > 0:
		velocity = velocity.normalized() * speed * 3	
	else:
		velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed('fire'):
		shoot()
		
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()
	
	if Input.is_action_just_pressed('reset'):
		getrekt()
		
func getrekt():
		var currentScene = get_tree().get_current_scene().get_filename()
		get_tree().change_scene(currentScene)
		

func _on_RollTime_timeout():
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)