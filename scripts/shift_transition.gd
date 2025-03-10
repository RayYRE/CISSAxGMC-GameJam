extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards('dissolve')
