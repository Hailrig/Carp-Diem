extends KinematicBody2D

func start(_position, animation):
	position = _position
	$Sprite/AnimationPlayer.play(animation)