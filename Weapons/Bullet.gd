extends Area2D

export (int) var speed
export (int) var damage
export (float) var lifetime

var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	velocity = _direction * speed
	
func _process(delta):
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(damage)
	_explode()


func _on_Lifetime_timeout():
	_explode()

func _explode():
	queue_free()