extends "res://Characters/Characters.gd"

signal charge

export (int) var detect_radius

var target = null
var direction 
var knockback = false

const POINT_RADIUS = 5


func _ready():
	connect("clip_fly", get_parent(), "_clip_fly")
	add_to_group(current_room)
	add_to_group("enemies")
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	
func _process(delta):
	if not alive:
		return
	if current_room != get_parent().get_node("Player").get("current_room"):
		return
	target = get_parent().get_node("Player")
	if target:
		aim()
#		var target_dir = (target.global_position - global_position).normalized()
#		var current_dir = Vector2(1, 0).rotated($Weapon.global_rotation)
#		$Weapon.global_rotation = target_dir.angle()
#		shoot()
		
		
		if path and knockback == false:
				# The next point is the first member of the path array
			var path_target = path[0]

		# Determine direction in which sidekick must move
			direction = (path_target - position).normalized()

		# Move sidekick
			position += direction * speed * delta

		# If we have reached the point...
			if position.distance_to(path_target) < POINT_RADIUS:

			# Remove first path point
				path.remove(0)

			# If we have no points left, remove path
				if path.size() == 0:
					path = null
				
func aim():
	$Weapon.rotation = (target.position - position).angle()
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		#hit_pos = result.position
		if result.collider.name == "Player":
			#$Weapon.rotation = (target.position - position).angle()
			shoot()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		target = body


func _on_Area2D_body_exited(body):
	if body ==  target:
		target = null
