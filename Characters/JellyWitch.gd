extends "res://Characters/BuffPuff.gd"

export (PackedScene) var rico

var i = 0

func spin_shot():
	$WeaponTimer.wait_time = 0.2
	clip_size = 20
	var dir = Vector2(1, 0).rotated($Weapon.global_rotation)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + .5)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation - .5)
	emit_signal('shoot', rico, $Weapon/Muzzle.global_position, dir)
	
func tri_shot():
	i += .05
	$WeaponTimer.wait_time = 0.05
	clip_size = 50
	var dir = Vector2(1, 0).rotated($Weapon.global_rotation + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + 1.5708 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + 3.14159 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)
	dir = Vector2(1, 0).rotated($Weapon.global_rotation + 4.71239 + i)
	emit_signal('shoot', Bullet, $Weapon/Muzzle.global_position, dir)