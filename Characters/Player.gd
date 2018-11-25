extends "res://Characters/Characters.gd"

signal charge
signal bullet_time
signal normal_time
signal time_change

export (float) var gracetime
export (int) var max_slow_time
#export (float) var slow_timer

var direction
var charge_target = null
var charge_target_free = null
var time_stop = false
var slow_time
var camera_offset

func _ready():
	if global.hp == null:
		global.hp = starting_health
	health = global.hp
	emit_signal('health_changed', health)
	slow_time = max_slow_time
	emit_signal('time_change', slow_time)
	$GraceTime.wait_time = gracetime
	#$SlowTimer.wait_time = slow_timer
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
		dashing = true
		
	if $BloodTimer.time_left > 0:
		var knockback_enemies = get_tree().get_nodes_in_group("knockback")
		for i in knockback_enemies:
			var velocity1 = (i.position - position).normalized() * speed * 3
			i.move_and_slide(velocity1)
		
	if charge_target:
		if charge_target.alive == true:
			var charge_target_dir = (charge_target.global_position - global_position).normalized()
			velocity = charge_target_dir * speed * 5
			if (charge_target.position.x - position.x < 60) and (charge_target.position.x - position.x > -60):
				if (charge_target.position.y - position.y < 60) and (charge_target.position.y - position.y > -60):
					chomp(delta)
		else:
			zoom = false
			charge_target = null;
			can_be_hurt = true;

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
		
	if Input.is_action_just_pressed('save'):
		get_parent().get_parent().get_node("Saver").save_game()
	
	if Input.is_action_just_pressed('load'):
		get_parent().get_parent().get_node("Loader").load_game()
		
	if Input.is_action_just_pressed('time_stop'):
		if time_stop:
			normal_time()
		else:
			time_stop()
	
	if time_stop:
		slow_time -= 4
		emit_signal('time_change', slow_time)
	elif time_stop == false and slow_time < max_slow_time:
		slow_time += 1
		emit_signal('time_change', slow_time)
	
	if slow_time <= 0:
		normal_time()
	
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
	emit_signal('normal_time')
	var mouse_pos = get_global_mouse_position()
	var bloodied_enemies = get_tree().get_nodes_in_group("bloodied_enemies")
	for i in bloodied_enemies:
		if (i.position.x - mouse_pos.x < 50) and (i.position.x - mouse_pos.x > -50):
			if (i.position.y - mouse_pos.y < 50) and (i.position.y - mouse_pos.y > -50):
				print('hey')
				var space_state = get_world_2d().direct_space_state
				var result = space_state.intersect_ray(position, i.position, [self], collision_mask)
				print(position)
				print(i.position)
				print([self])
				print(collision_mask)
				#var hit_pos = result.position
				#draw_circle((hit_pos - position).rotated(-rotation), 5, Color(1.0, .329, .298))
				print(result)
				if result:
					if result.collider == i:
						charge_target = i;
						charge_target_free = weakref(i);
						can_be_hurt = false
						zoom = true

				
func chomp(delta):
	gain_life(1)
	var enemies = get_tree().get_nodes_in_group("enemies")
	for i in enemies:
		if (i.position.x - position.x < 150) and (i.position.x - position.x > -150):
			if (i.position.y - position.y < 150) and (i.position.y - position.y > -150):
				i.add_to_group("knockback")
				i.knockback = true
	charge_target.getrekt()
	charge_target = null
	can_be_hurt = true
	emit_signal('bullet_time')
	$BloodTimer.start()
	zoom = false

func time_stop():
	#$SlowTimer.start()
	time_stop = true
	emit_signal('bullet_time')
	
func normal_time():
	time_stop = false
	emit_signal('normal_time')

func _on_BloodTimer_timeout():
	var knockback_enemies = get_tree().get_nodes_in_group("knockback")
	for i in knockback_enemies:
		i.knockback = false
		i.remove_from_group("knockback")
	blood_dash()


func take_damage(amount):
	if can_be_hurt:
		can_be_hurt = false
		$GraceTime.start()
		$Body/AnimationPlayer2.play('Invuln')
		health -= amount
		emit_signal('health_changed', health)
		global.hp -= amount
		#print(global.hp)
		if health <= 0:
			getrekt()
			
func gain_life(amount):
	if (health + amount) < max_health:
		health += amount
		global.hp += amount
	else:
		health = max_health
		global.hp = max_health
	emit_signal('health_changed', health)

func getrekt():
#		var currentScene = get_tree().get_current_scene().get_filename()
#		get_tree().change_scene(currentScene)
	global.hp = starting_health
	get_tree().reload_current_scene()
		#Loader.load_game()
		
func _camera_shift():
	$Camera2D.align()
	$Camera2D.offset = Vector2(0,0)
	camera_offset = Vector2(get_global_mouse_position() - global_position)
	camera_offset = camera_offset / 5
	$Camera2D.offset += camera_offset


func _on_RollTime_timeout():
	set_collision_layer_bit(1, true)
	set_collision_layer_bit(4, false)
	dashing = false

func _on_GraceTime_timeout():
	can_be_hurt = true