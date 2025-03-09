extends TileMapLayer

var tween: Tween

func swap_layers_with_fade(from_layer: int, to_layer: int, duration: float = 1.0):
	tween = create_tween()
	
	# Fade out the first layer
	tween.tween_property(self, "tile_set.get_source(from_layer).modulate:a", 0, duration)
	
	# Fade in the second layer
	tween.parallel().tween_property(self, "tile_set.get_source(to_layer).modulate:a", 1, duration)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("phaseshift"):  # Press Enter to swap layers
		swap_layers_with_fade(0, 1, 1.5)
