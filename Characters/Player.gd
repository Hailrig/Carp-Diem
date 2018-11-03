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
		
	dont_shoot_yourself(shot_dir)
	
	if Input.is_action_just_pressed('fire'):
		shoot()
		
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()
	
	if Input.is_action_just_pressed('reset'):
		getrekt()
		
	_camera_shift()
	
func dont_shoot_yourself(gun_face):
	if gun_face == 'right':
		if $Weapon.global_rotation_degrees > 110:
			$Weapon.global_rotation_degrees = 110 
		elif $Weapon.global_rotation_degrees < -110:
			$Weapon.global_rotation_degrees = -110
	elif gun_face == 'left':
		if $Weapon.global_rotation_degrees < 70 and $Weapon.global_rotation_degrees > 0:
			$Weapon.global_rotation_degrees = 70 
		elif $Weapon.global_rotation_degrees > -70 and $Weapon.global_rotation_degrees < 0:
			$Weapon.global_rotation_degrees = -70


func getrekt():
		var currentScene = get_tree().get_current_scene().get_filename()
		get_tree().change_scene(currentScene)
		
func _camera_shift():
	$Camera2D.align()
	$Camera2D.offset = Vector2(0,0)
	var camera_offset = Vector2(get_global_mouse_position() - global_position)
	camera_offset = camera_offset / 5
	$Camera2D.offset += camera_offset


func _on_RollTime_timeout():
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)