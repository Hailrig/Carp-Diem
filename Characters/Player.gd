extends "res://Characters/Characters.gd"

signal charge

export (float) var gracetime

var direction
var charge_target = null

func _ready():
	$GraceTime.wait_time = gracetime
	add_to_group("players")

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
		
	if charge_target:
		var charge_target_dir = (charge_target.global_position - global_position).normalized()
		velocity = charge_target_dir * speed * 3
		if (charge_target.position.x - position.x < 50) and (charge_target.position.x - position.x > -50):
			if (charge_target.position.y - position.y < 50) and (charge_target.position.y - position.y > -50):
				chomp()
	elif $RollTime.time_left > 0:
		velocity = velocity.normalized() * speed * 3
	else:
		velocity = velocity.normalized() * speed
		emit_signal('charge')
		
	dont_shoot_yourself(shot_dir)
	
	if Input.is_action_just_pressed('blood_dash'):
		blood_dash()
	
	if Input.is_action_just_pressed('fire'):
		shoot()
		
	if Input.is_action_just_pressed('reload'):
		reload()
		
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()
	
	if Input.is_action_just_pressed('reset'):
		getrekt()
		
	_camera_shift()
	
func dont_shoot_yourself(gun_face):
	if gun_face == 'right':
		if $Weapon.global_rotation_degrees > 110:
			if playing_anim < 4 or (playing_anim > 6 and playing_anim < 10):
				$Weapon.global_rotation_degrees = 110 
			else:
				$Weapon.global_rotation_degrees = -110 
		elif $Weapon.global_rotation_degrees < -110:
			if playing_anim < 4 or (playing_anim > 6 and playing_anim < 10):
				$Weapon.global_rotation_degrees = 110 
			else:
				$Weapon.global_rotation_degrees = -100
			
	elif gun_face == 'left':
		if $Weapon.global_rotation_degrees < 70 and $Weapon.global_rotation_degrees > 0:
			if playing_anim < 4 or (playing_anim > 6 and playing_anim < 10):
				$Weapon.global_rotation_degrees = 70 
			else:
				$Weapon.global_rotation_degrees = -70 
		elif $Weapon.global_rotation_degrees > -70 and $Weapon.global_rotation_degrees < 0:
			if playing_anim < 4 or (playing_anim > 6 and playing_anim < 10):
				$Weapon.global_rotation_degrees = 70 
			else:
				$Weapon.global_rotation_degrees = -70 
				
func blood_dash():
	var mouse_pos = get_global_mouse_position()
	var bloodied_enemies = get_tree().get_nodes_in_group("bloodied_enemies")
	for i in bloodied_enemies:
		if (i.position.x - mouse_pos.x < 50) and (i.position.x - mouse_pos.x > -50):
			if (i.position.y - mouse_pos.y < 50) and (i.position.y - mouse_pos.y > -50):
					var space_state = get_world_2d().direct_space_state
					var result = space_state.intersect_ray(position, i.position, [self], collision_mask)
					if result:
						if result.collider == i:
							charge_target = i
							can_be_hurt = false
				
func chomp():
	charge_target.getrekt()
	gain_life(1)
	charge_target = null
	can_be_hurt = true


func take_damage(amount):
	if can_be_hurt:
		can_be_hurt = false
		$GraceTime.start()
		$Body/AnimationPlayer2.play('Invuln')
		health -= amount
		emit_signal('health_changed', health)
		if health <= 0:
			getrekt()

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

func _on_GraceTime_timeout():
	can_be_hurt = true
