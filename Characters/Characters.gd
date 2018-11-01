extends KinematicBody2D

signal shoot
signal health_changed
signal dead

export (PackedScene) var Bullet
export (int) var speed
export (float) var weapon_cooldown
export (int) var max_health
export (int) var starting_health

var velocity = Vector2()
var can_shoot = true
var alive = true
var health

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
	
func change_anim(angle, velocity):
	if velocity.x == 0 and velocity.y == 0:
		pass

	
func take_damage(amount):
	health -= amount
	emit_signal('health_changed', health)
	if health <= 0:
		getrekt()
		
func getrekt():
	queue_free()

func _on_WeaponTimer_timeout():
	can_shoot = true
