extends KinematicBody2D

signal shoot
signal health_changed
signal dead
signal ammo_changed
signal take_damage

export (PackedScene) var Bullet
export (int) var speed
export (float) var weapon_cooldown
export (int) var max_health
export (int) var starting_health
export (int) var weapon_offset
export (int) var clip_size
export (int) var reload_timer

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

var velocity = Vector2()
var can_shoot = true
var alive = true
var health
var playing_anim = 0
var shot_dir
var _in_clip
var can_be_hurt = true
var bloodied = false

func _ready():
	_in_clip = clip_size
	health = starting_health
	$WeaponTimer.wait_time = weapon_cooldown
	$ReloadTimer.wait_time = reload_timer
	emit_signal('health_changed', health)
	emit_signal('ammo_changed', _in_clip)
	
func control(delta):
	pass
	
func shoot():
#		if _in_clip >= 0:
	if can_shoot:
		if _in_clip > 0:
			_in_clip -= 1
			$Weapon/AudioStreamPlayer2D.play()
			emit_signal('ammo_changed', _in_clip)
			can_shoot = false
			$WeaponTimer.start()
			var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
			emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
		elif $ReloadTimer.time_left == 0:
			reload()

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	move_and_slide(velocity)
	change_anim(rad2deg($Body.get_angle_to(get_global_mouse_position())), velocity)
	
func change_anim(angle, velocity):
	if velocity.x == 0 and velocity.y == 0:
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

	if angle >= 105 or angle <= -105:
		shot_dir = 'left'
		$Weapon.flip_v = true
		$Weapon.position.x = -weapon_offset
		$Arm.position.x = weapon_offset - 3
	elif angle <= 75 and angle >= -75:
		shot_dir = 'right'
		$Weapon.flip_v = false
		$Weapon.position.x = weapon_offset
		$Arm.position.x = -weapon_offset + 3
		
	if bloodied:
		$Body.self_modulate = Color(255, 0, 0, 255)
	
func reload():
	_in_clip = 0
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
	set_collision_layer_bit(5, true)
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(1, false)
	set_collision_mask_bit(2, false)
	for i in 20:
		print(get_collision_mask_bit(i))
	$Body.self_modulate = Color(1, 1, 1, .5)
	$Body/AudioStreamPlayer2D.play()
	remove_from_group('enemies')
	remove_from_group('bloodied_enemies')
	$Weapon.queue_free()
	alive = false

func _on_WeaponTimer_timeout():
	can_shoot = true


func _on_ReloadTimer_timeout():
	_in_clip = clip_size
	emit_signal('ammo_changed', _in_clip)
