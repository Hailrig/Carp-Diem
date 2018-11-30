extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

var velocity = Vector2()
var dead

func start(_position, _direction, flash = "flash"):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed
	$AnimationPlayer.play(flash)
	
func _process(delta):
	if !dead:
		position += velocity * delta

func _on_Bullet_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	if body.has_method('makefree'):
		print("fuckshit")
		body.makefree()
	_explode()


func _on_Lifetime_timeout():
	_explode()

func _explode():
	rotation = rotation + 3.14159
	$AnimationPlayer.play("hit")
	dead = true
	$HitTime.start()

func _on_HitTime_timeout():
	queue_free()
