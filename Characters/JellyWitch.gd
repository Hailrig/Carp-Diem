extends "res://Characters/BuffPuff.gd"

export (PackedScene) var rico

var i = 0

func _ready():
	flash = "lightning"

func shoot():
#		if _in_clip >= 0:
	if can_shoot:
		if _in_clip > 0:
			_in_clip -= 1
			$Weapon/AudioStreamPlayer2D.play()
			emit_signal('ammo_changed', _in_clip)
			can_shoot = false
			$WeaponTimer.start()
			
			
			if health >= 160:
				tri_shot()
			elif fire_mode == 0:
				tri_shot()
			elif fire_mode == 1:
				spin_shot()
		elif $ReloadTimer.time_left == 0:
			reload()

func spin_shot():
	$WeaponTimer.wait_time = 0.2
	clip_size = 20
	var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir, flash)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + .5)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir, flash)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation - .5)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir, flash)
	
func tri_shot():
	i += .05
	$WeaponTimer.wait_time = 0.05
	clip_size = 50
	var dir = Vector2(1, 0).rotated(i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir, flash)
	dir = Vector2(1, 0).rotated(1.5708 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir, flash)
	dir = Vector2(1, 0).rotated(3.14159 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir, flash)
	dir = Vector2(1, 0).rotated(4.71239 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir, flash)
	
func take_damage(amount):
	if can_be_hurt:
		emit_signal('take_damage', 0.1)
		health -= amount
		emit_signal('health_changed', health)
		if health == 180 or health == 160 or health == 140 or health == 120:
			can_be_hurt = false
			bloodied = true
			add_to_group("bloodied_enemies")
			boss_bar = true
		if health <= 0:
			getrekt()
		if health <= (starting_health/2):
			bloodied = true
			add_to_group("bloodied_enemies")