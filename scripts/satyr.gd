extends CharacterBody2D
class_name Satyr

@export var Coyote_Time: float = 0.1
@onready var coyote_timer: Timer = $Coyote_Timer

const SPEED = 100.0
const JUMP_VELOCITY = -165.0
var Jump_Available: bool = true
var Jump_Buffer: bool = false


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D 
var retry_popup
var is_dying = 0
var is_dead = 0

func _physics_process(delta: float) -> void:
	
	# Gravity
	if not is_on_floor():
		if Jump_Available:
			if coyote_timer.is_stopped():
				coyote_timer.start(Coyote_Time)
			#get_tree().create_timer(Coyote_Time).timeout.connect(Coyote_Timeout)
		
		velocity += get_gravity() * delta
		
	else:
		Jump_Available = true
		coyote_timer.stop()

	if is_dying:
		animated_sprite.play("death")
		await get_tree().create_timer(1).timeout
		is_dead = 1
		is_dying = 0
		return
		
	if is_dead:
		animated_sprite.play("dead")
		return

	# Jump
	if Input.is_action_just_pressed("jump") and Jump_Available:
		velocity.y = JUMP_VELOCITY
		Jump_Available = false

	# Facing Direction
	var direction := Input.get_axis("move_left", "move_right")
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
	is_dying = 1
	await get_tree().create_timer(1.5).timeout
	retry_popup = preload("res://scenes/death_screen.tscn").instantiate()
	retry_popup.position = %Camera2D.global_position
	get_tree().current_scene.add_child(retry_popup)
	

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player_death()


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	player_death()


func _on_void_body_entered(body: Node2D) -> void:
	await get_tree().create_timer(0.5).timeout
	player_death()

func Coyote_Timeout():
	Jump_Available = true
