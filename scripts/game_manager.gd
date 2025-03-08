extends Node

var player_position: Vector2

func swap_worlds(new_world_path: String):
	# Store the player's position
	var player = get_tree().current_scene.get_node("Player")
	player_position = player.global_position

	# Load the new world
	var new_world = load(new_world_path).instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(new_world)
	get_tree().current_scene = new_world

	# Set the player's position in the new world
	var new_player = new_world.get_node("Player")
	new_player.global_position = player_position
