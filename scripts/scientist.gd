extends CharacterBody2D

const SPEED: float = 50.0   
const DETECT_RANGE: float = 100.0
const JUMP_STRENGTH: float = 100.0

@onready var tilemap_origin: Node = get_tree().current_scene.get_node("Lab")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Satyr")

func _physics_process(delta: float) -> void:
	# Disable enemy if tilemap origin is inactive
	var is_active = tilemap_origin.is_enabled()
	collision_shape.set_deferred("disabled", not is_active)
	visible = is_active
	
	if not is_active or player.is_dying or player.is_dead:
		velocity.x = 0
		animated_sprite.play("idle")
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta 

	# Check for player detection
	if global_position.distance_to(player.global_position) < DETECT_RANGE:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED  
		animated_sprite.flip_h = direction.x < 0
		
		# Jump if the player is above the enemy
		if player.global_position.y < global_position.y - 0 and is_on_floor() and is_on_wall():
			velocity.y = -JUMP_STRENGTH
			
		# Play walking or idle animation
		if is_on_floor():
			animated_sprite.play("walk" if abs(velocity.x) > 1 else "idle")
			
	else:
		animated_sprite.play("idle")
		velocity.x = 0
	
	move_and_slide()
