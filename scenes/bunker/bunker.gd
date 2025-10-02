extends Node2D


func bunker_hit() -> void:
	$BunkerHitSFX.pitch_scale = randf_range(0.95, 1.05)
	$BunkerHitSFX.play()
