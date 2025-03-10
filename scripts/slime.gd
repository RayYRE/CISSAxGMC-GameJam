extends CharacterBody2D

const SPEED: float = 50.0   
const DETECT_RANGE: float = 100.0
const JUMP_STRENGTH: float = 120.0
const MAX_JUMP_COOLDOWN = 2

@onready var tilemap_origin: Node = get_tree().current_scene.get_node("Future")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Satyr")
@onready var jump_cooldown = 0

func _physics_process(delta: float) -> void:
	# Disable enemy if origin tilemap is inactive
	jump_cooldown -= delta
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
		animated_sprite.flip_h = direction.x < 0
		
		# Jump if on floor or no cooldown
		if is_on_floor():
			velocity.x = 0
			animated_sprite.play("idle")
			if jump_cooldown < 0:
				jump_cooldown = MAX_JUMP_COOLDOWN
				velocity.y = -JUMP_STRENGTH
		else:
			animated_sprite.play("walk")
			velocity.x = direction.x * SPEED  
	else:
		animated_sprite.play("idle")
		velocity.x = 0
	
	move_and_slide()
