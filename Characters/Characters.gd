extends KinematicBody2D

signal shoot
signal health_changed
signal dead

export (PackedScene) var Bullet
export (int) var speed
export (float) var weapon_cooldown
export (int) var max_health
export (int) var starting_health
export (int) var weapon_offset

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

func _ready():
	health = starting_health
	$WeaponTimer.wait_time = weapon_cooldown
	emit_signal('health_changed', health)
	
func control(delta):
	pass
	
func shoot():
	if can_shoot:
		can_shoot = false
		$WeaponTimer.start()
		var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
		emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)

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
		if angle > 0 and angle <= 45 and playing_anim != 1:
			$Body/AnimationPlayer.play(front_right_walk)
			playing_anim = 1
		if angle > 45 and angle <= 135 and playing_anim != 2:
			$Body/AnimationPlayer.play(front_walk)
			playing_anim = 2
		if angle > 135  and angle <= 180 and playing_anim != 3:
			$Body/AnimationPlayer.play(front_left_walk)
			playing_anim = 3
		if angle > -180 and angle <= -135 and playing_anim != 4:
			$Body/AnimationPlayer.play(back_left_walk)
			playing_anim = 4
		if angle > -135 and angle <= -45 and playing_anim != 5:
			$Body/AnimationPlayer.play(back_walk)
			playing_anim = 5
		if angle > -45 and angle <= 0 and playing_anim != 6:
			$Body/AnimationPlayer.play(back_right_walk)
			playing_anim = 6

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
	
		

	
func take_damage(amount):
	health -= amount
	emit_signal('health_changed', health)
	if health <= 0:
		getrekt()
		
func getrekt():
	queue_free()

func _on_WeaponTimer_timeout():
	can_shoot = true
