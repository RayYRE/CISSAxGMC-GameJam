extends Node2D

@onready var tilemap_world1 = $TileMapLayerPresent
@onready var tilemap_world2 = $TileMapLayerFuture
@onready var enemies_group = [] 
var is_world1_active = true

func _ready() -> void:
	enemies_group = get_tree().get_nodes_in_group("enemies") 
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
		set_enemies_visibility(false)
	else:
		tilemap_world1.set_enabled(true)
		tilemap_world2.set_enabled(false)
		is_world1_active = true
		set_enemies_visibility(true)
	
func set_enemies_visibility(is_visible: bool) -> void:
	for enemy in enemies_group:
		enemy.visible = is_visible
