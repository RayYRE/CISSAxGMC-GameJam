extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -160.0


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 
var retry_popup

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the Player
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func player_death():
	retry_popup = preload("res://scenes/death_screen.tscn").instantiate()
	retry_popup.position = %Camera2D.global_position
	get_tree().current_scene.add_child(retry_popup)
	

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	await get_tree().create_timer(0.5).timeout
	player_death()


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	player_death()


func _on_void_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	player_death()
