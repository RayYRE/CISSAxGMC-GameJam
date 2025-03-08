extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If space bar pressed, world switch
	if Input.is_action_just_pressed("phaseshift"):
		GameManager.swap_worlds("res://scenes/game.tscn")
	pass
