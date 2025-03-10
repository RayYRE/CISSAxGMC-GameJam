extends Node2D

@onready var ORIGINALWORLD = %Lab
@onready var NOHUMANSWORLD = %Future
@onready var PLAYER:= %Satyr
var current_world = ORIGINALWORLD
var other_world = NOHUMANSWORLD
var start = 0
var phasecooldown = false
 
func _process(delta: float) -> void:
	if start == 0:
		%Lab.set_enabled(true)
		%LabBackgrounds.show()
		%Future.set_enabled(false)
		%FutureBackground.hide()
		start = 1
	
	if Input.is_action_just_pressed("phaseshift") and not PLAYER.is_dying and not PLAYER.is_dead:
		if phasecooldown == false:
			swap_worlds()
			phasecooldown = true
			await get_tree().create_timer(0.4).timeout
			phasecooldown = false
		pass
	
func swap_worlds():
	
	ShiftTransition.change_scene("res://scripts/qihantestmap.gd")
	
	await get_tree().create_timer(0.2).timeout
	
	# Store the player's position
	if %Lab.is_enabled():
		world_swap_handler(%Lab, %Future)
		%LabBackgrounds.hide()
		%FutureBackground.show()
		%Platform1.set_collision_layer_value(2, false)
		current_world = NOHUMANSWORLD
		other_world = ORIGINALWORLD
	else:
		world_swap_handler(%Future, %Lab)
		%Platform1.set_collision_layer_value(2, true)
		%LabBackgrounds.show()
		%FutureBackground.hide()

		
		current_world = ORIGINALWORLD
		other_world = NOHUMANSWORLD
		
		
func world_swap_handler(current_world, swap_to_world):
	current_world.set_enabled(false)
	swap_to_world.set_enabled(true)
