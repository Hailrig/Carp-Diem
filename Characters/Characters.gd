extends KinematicBody2D

signal shoot
signal health_changed
signal dead
signal ammo_changed
signal take_damage
signal clip_fly

export (PackedScene) var Bullet
export (PackedScene) var clip
export (int) var speed
export (float) var weapon_cooldown
export (int) var max_health
export (int) var starting_health
export (int) var weapon_offset
export (int) var clip_size
export (int) var reload_timer
export (int) var weapon_shift
export (bool) var clips
export (float) var clip_timer
export (String) var clip_anim
export (bool) var shells
export (String) var shell_anim
export (String) var gun_swap
export (String) var gun

export (String) var current_room

export (String) var front_idle
export (String) var front_right_idle
export (String) var front_left_idle
export (String) var back_idle
export (String) var back_left_idle
export (String) var back_right_idle

export (String) var front_walk
export (String) var front_right_walk
export (String) var front_left_walk
export (String) var back_walk
export (String) var back_left_walk
export (String) var back_right_walk

export (String) var front_dash
export (String) var front_right_dash
export (String) var front_left_dash
export (String) var back_dash
export (String) var back_left_dash
export (String) var back_right_dash

export (String) var front_blood
export (String) var front_right_blood
export (String) var front_left_blood
export (String) var back_blood
export (String) var back_left_blood
export (String) var back_right_blood

export (String) var reload_right
export (String) var reload_left

var velocity = Vector2()
var can_shoot = true
var alive = true
var health
var playing_anim = 0
var shot_dir
var _in_clip
var can_be_hurt = true
var bloodied = false
var dashing = false
var zoom = false
var path = null

func _ready():
#	if name == "Player":
#		pass
#		health = starting_health
#		emit_signal('health_changed', health)
	health = starting_health
#	$WeaponTimer.wait_time = weapon_cooldown
#	$ReloadTimer.wait_time = reload_timer
#	$ClipTimer.wait_time = clip_timer
#	_in_clip = clip_size
	gun_setup(gun_swap)
#	emit_signal('ammo_changed', _in_clip)
	
func control(delta):
	pass
	
func gun_setup(gun_swap):
	$Weapon/AnimationPlayer.play(gun_swap)
	print(gun)
	if gun_swap == "pistol_swap":
		weapon_cooldown = 1
		clip_size = 5
		reload_timer = 1
		clips = true
		clip_anim = "9mil_drop"
		shells = true
		shell_anim = "shell_fly"
		reload_right = "a"
		reload_left = "a"
	if gun_swap == "shrimp_swap":
		weapon_cooldown = 0.3
		clip_size = 8
		reload_timer = 1
		clips = true
		clip_anim = "shrimp_toss"
		shells = false
		shell_anim = null
		reload_right = "reload"
		reload_left = "reload_left"
	if gun_swap == "shotti_swap":
		weapon_cooldown = 0.6
		clip_size = 5
		reload_timer = 1
		clips = false
		clip_anim = "shrimp_toss"
		shells = true
		shell_anim = "shell_fly"
		reload_right = "a"
		reload_left = "a"
		
	$WeaponTimer.wait_time = weapon_cooldown
	$ReloadTimer.wait_time = reload_timer
	$ClipTimer.wait_time = clip_timer
	_in_clip = clip_size
	emit_signal('ammo_changed', _in_clip)
	
func shoot():
#		if _in_clip >= 0:
	if can_shoot:
		if _in_clip > 0:
			_in_clip -= 1
			$Weapon/AudioStreamPlayer2D.play()
			emit_signal('ammo_changed', _in_clip)
			can_shoot = false
			$WeaponTimer.start()
#			var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
#			emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
			if gun == "pistol" or gun == "shrimp":
				pistol()
			if gun == "shotti":
				shotti()
			if shells:
				emit_signal("clip_fly", clip, $Weapon.global_position, shell_anim)
		elif $ReloadTimer.time_left == 0:
			reload()

func pistol():
	var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	
func shotti():
	var dir = Vector2(1, 0).rotated($Weapon.global_rotation - 0.25)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + 0.25)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
	change_anim(rad2deg($Body.get_angle_to(get_global_mouse_position())), rad2deg($Weapon.global_rotation), velocity)
	
func change_anim(body_angle, angle, velocity):
	if velocity.x == 0 and velocity.y == 0 and path == null:
		if angle > 0 and angle <= 45 and playing_anim != 1:
			$Body/AnimationPlayer.play(front_right_idle)
			playing_anim = 1
		if angle > 45 and angle <= 135 and playing_anim != 2:
			$Body/AnimationPlayer.play(front_idle)
			playing_anim = 2
		if angle > 135  and angle <= 180 and playing_anim != 3:
			$Body/AnimationPlayer.play(front_left_idle)
			playing_anim = 3
		if angle > -180 and angle <= -135 and playing_anim != 4:
			$Body/AnimationPlayer.play(back_left_idle)
			playing_anim = 4
		if angle > -135 and angle <= -45 and playing_anim != 5:
			$Body/AnimationPlayer.play(back_idle)
			playing_anim = 5
		if angle > -45 and angle <= 0 and playing_anim != 6:
			$Body/AnimationPlayer.play(back_right_idle)
			playing_anim = 6
	elif dashing == true:
		if angle > 0 and angle <= 45 and playing_anim != 13:
			$Body/AnimationPlayer.play(front_right_dash)
			playing_anim = 13
		if angle > 45 and angle <= 135 and playing_anim != 14:
			$Body/AnimationPlayer.play(front_dash)
			playing_anim = 14
		if angle > 135  and angle <= 180 and playing_anim != 15:
			$Body/AnimationPlayer.play(front_left_dash)
			playing_anim = 15
		if angle > -180 and angle <= -135 and playing_anim != 16:
			$Body/AnimationPlayer.play(back_left_dash)
			playing_anim = 16
		if angle > -135 and angle <= -45 and playing_anim != 17:
			$Body/AnimationPlayer.play(back_dash)
			playing_anim = 17
		if angle > -45 and angle <= 0 and playing_anim != 18:
			$Body/AnimationPlayer.play(back_right_dash)
			playing_anim = 18
	elif zoom == true:
		if angle > 0 and angle <= 45 and playing_anim != 19:
			$Body/AnimationPlayer.play(front_right_blood)
			playing_anim = 19
		if angle > 45 and angle <= 135 and playing_anim != 20:
			$Body/AnimationPlayer.play(front_blood)
			playing_anim = 20
		if angle > 135  and angle <= 180 and playing_anim != 20:
			$Body/AnimationPlayer.play(front_left_blood)
			playing_anim = 20
		if angle > -180 and angle <= -135 and playing_anim != 20:
			$Body/AnimationPlayer.play(back_left_blood)
			playing_anim = 20
		if angle > -135 and angle <= -45 and playing_anim != 20:
			$Body/AnimationPlayer.play(back_blood)
			playing_anim = 20
		if angle > -45 and angle <= 0 and playing_anim != 20:
			$Body/AnimationPlayer.play(back_right_blood)
			playing_anim = 20
	else:
		if angle > 0 and angle <= 45 and playing_anim != 7:
			$Body/AnimationPlayer.play(front_right_walk)
			playing_anim = 7
		if angle > 45 and angle <= 135 and playing_anim != 8:
			$Body/AnimationPlayer.play(front_walk)
			playing_anim = 8
		if angle > 135  and angle <= 180 and playing_anim != 9:
			$Body/AnimationPlayer.play(front_left_walk)
			playing_anim = 9
		if angle > -180 and angle <= -135 and playing_anim != 10:
			$Body/AnimationPlayer.play(back_left_walk)
			playing_anim = 10
		if angle > -135 and angle <= -45 and playing_anim != 11:
			$Body/AnimationPlayer.play(back_walk)
			playing_anim = 11
		if angle > -45 and angle <= 0 and playing_anim != 12:
			$Body/AnimationPlayer.play(back_right_walk)
			playing_anim = 12

	if $ReloadTimer.time_left > 0:
		pass
	else:
		if name == "Player":
			if body_angle >= 105 or body_angle <= -105:
				shot_dir = 'left'
				$Weapon.flip_v = true
				$Weapon.position.x = -weapon_offset
				$Arm.position.x = weapon_offset - 3
				$Weapon.offset.y = weapon_shift
			elif body_angle <= 75 and body_angle >= -75:
				shot_dir = 'right'
				$Weapon.flip_v = false
				$Weapon.position.x = weapon_offset
				$Arm.position.x = -weapon_offset + 3
				$Weapon.offset.y = -weapon_shift
		else:
			if angle >= 105 or angle <= -105:
				shot_dir = 'left'
				$Weapon.flip_v = true
				$Weapon.position.x = -weapon_offset
				$Arm.position.x = weapon_offset - 3
				$Weapon.offset.y = weapon_shift
			elif angle <= 75 and angle >= -75:
				shot_dir = 'right'
				$Weapon.flip_v = false
				$Weapon.position.x = weapon_offset
				$Arm.position.x = -weapon_offset + 3
				$Weapon.offset.y = -weapon_shift
		
	if bloodied:
		$Body.self_modulate = Color(255, 0, 0, 255)
	
func reload():
	_in_clip = 0
	if shot_dir == 'right':
		$Weapon/AnimationPlayer.play(reload_right)
	elif shot_dir == 'left':
		$Weapon/AnimationPlayer.play(reload_left)
#		pass play left offset animation
#	emit_signal("clip_fly", clip, $Weapon.global_position)
	if clips:
		$ClipTimer.start()
	$ReloadTimer.start()
	
func take_damage(amount):
	if can_be_hurt:
		emit_signal('take_damage', 0.1)
		health -= amount
		emit_signal('health_changed', health)
		if health <= 0:
			getrekt()
		if health <= (starting_health/2):
			bloodied = true
			add_to_group("bloodied_enemies")
		
func gain_life(amount):
	if (health + amount) < max_health:
		health += amount
	else:
		health = max_health
	emit_signal('health_changed', health)
	
func getrekt():
	if !alive:
		return
	alive = false
	emit_signal('dead')
	path = null
	change_anim(rad2deg($Body.get_angle_to(get_global_mouse_position())), rad2deg($Weapon.global_rotation), velocity)
	set_collision_layer_bit(5, true)
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)
	$Body.self_modulate = Color(1, 1, 1, .5)
	$Body/AudioStreamPlayer2D.play()
	remove_from_group('enemies')
	remove_from_group('bloodied_enemies')
	remove_from_group(current_room)
	$Weapon.queue_free()

func _on_WeaponTimer_timeout():
	can_shoot = true


func _on_ReloadTimer_timeout():
	_in_clip = clip_size
	emit_signal('ammo_changed', _in_clip)


func _on_ClipTimer_timeout():
	if !alive:
		return
	emit_signal("clip_fly", clip, $Weapon.global_position, clip_anim)
