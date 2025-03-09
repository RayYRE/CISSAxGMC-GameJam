extends CharacterBody2D

@export var speed: float = 50.0  
@export var gravity: float = 980.0  
@export var detect_range: float = 100.0
@export var jump_force: float = 200.0

@onready var tilemap_origin: Node = get_tree().current_scene.get_node("TileMapLayerFuture")
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player: CharacterBody2D = get_tree().current_scene.get_node("Satyr")

func _physics_process(delta: float) -> void:
	# Disable enemy if origin tilemap is inactive
	var is_active = tilemap_origin.is_enabled()
	collision_shape.set_deferred("disabled", not is_active)
	visible = is_active
	
	if not is_active:
		velocity.x = 0
		return
	
	animated_sprite.play("walk")
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta 

	# Check for player detection
	if global_position.distance_to(player.global_position) < detect_range:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed  
		animated_sprite.flip_h = direction.x > 0
		
		# Jump if the player is above the enemy
		if player.global_position.y < global_position.y - 0 and is_on_floor() and is_on_wall():
			velocity.y = -jump_force
			
	else:
		velocity.x = 0
	
	move_and_slide()
