extends Node2D

@onready var ORIGINALWORLD = %Original
@onready var NOHUMANSWORLD = %OtherWorld
@onready var PLAYER:= %Satyr
var current_world = ORIGINALWORLD
var other_world = NOHUMANSWORLD
var start = 0


func _process(delta: float) -> void:
	if start == 0:
		%Original.set_enabled(false)
		%OtherWorld.set_enabled(true)
		start = 1
	
	if Input.is_action_just_pressed("phaseshift"):
		swap_worlds()
		pass
	
func swap_worlds():
	# Store the player's position
	if current_world == ORIGINALWORLD:
		world_swap_handler(%Original, %OtherWorld)
		current_world = NOHUMANSWORLD
		other_world = ORIGINALWORLD
	else:
		world_swap_handler(%OtherWorld, %Original)
		current_world = ORIGINALWORLD
		other_world = NOHUMANSWORLD
		
		
func world_swap_handler(current_world, swap_to_world):
	current_world.set_enabled(false)
	swap_to_world.set_enabled(true)
