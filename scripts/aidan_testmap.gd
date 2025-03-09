extends Node2D

@onready var tilemap_world1 = $TileMapLayerPresent
@onready var tilemap_world2 = $TileMapLayerFuture
var is_world1_active = true

func _ready() -> void:
	tilemap_world1.set_enabled(true)
	tilemap_world2.set_enabled(false)
	pass 

func _process(delta: float) -> void:
	# If space bar pressed, world switch
	if Input.is_action_just_pressed("phaseshift"):
		swap_worlds()
	pass
# Call this function to swap the world by hiding/showing tilemaps
func swap_worlds():
	if is_world1_active:
		tilemap_world1.set_enabled(false)
		tilemap_world2.set_enabled(true)
		is_world1_active = false
	else:
		tilemap_world1.set_enabled(true)
		tilemap_world2.set_enabled(false)
		is_world1_active = true
