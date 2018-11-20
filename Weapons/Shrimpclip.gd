extends KinematicBody2D

func start(_position):
	position = _position
	$Sprite/AnimationPlayer.play("shrimp_toss")