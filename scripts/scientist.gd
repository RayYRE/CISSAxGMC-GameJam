extends CharacterBody2D

@export var speed: float = 50.0  
@export var gravity: float = 980.0  
@export var detect_range: float = 100.0
@export var lose_range: float = 20.0  
@onready var tilemap_world1 = get_tree().current_scene.get_node("TileMapLayerPresent")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player = null  
@onready var game = null

func _ready() -> void:
	player = get_tree().current_scene.get_node("Satyr") 
	
func _physics_process(delta: float) -> void:
	if tilemap_world1.is_enabled():
		collision_shape.set_deferred("disabled", false)
		if not is_on_floor():
			velocity.y += gravity * delta 
		if global_position.distance_to(player.global_position) < detect_range:
			var direction = (player.global_position - global_position).normalized()
			velocity.x = direction.x * speed  
			animated_sprite.flip_h = direction.x < 0

			if is_on_floor():
				if abs(velocity.x) > 1:
					animated_sprite.play("walk")
				else:
					animated_sprite.play("idle")

			if global_position.distance_to(player.global_position) < lose_range:
				print("Player lost!")
		else:
			animated_sprite.play("idle")
			velocity.x = 0
	else:
		collision_shape.set_deferred("disabled", true) 
		
	move_and_slide()
