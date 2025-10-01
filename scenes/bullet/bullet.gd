extends Area2D

var bullet_speed := 300
var bullet_direction := -1


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.y += bullet_speed * bullet_direction * delta


func _on_area_entered(area: Node2D) -> void:
	$HitSFX.pitch_scale = randf_range(0.9, 1.1)
	$HitSFX.play()
	if area.is_in_group("bullet"):
		await get_parent().hit_stop(0.1)
		queue_free()
	if area.is_in_group("alien"):
		area.hit_flash_player.play("hit_flash")
		await get_parent().hit_stop(0.3)
		area.destroy()
		queue_free()
	if area.is_in_group("mothership"):
		area.hit_flash_player.play("hit_flash")
		await get_parent().hit_stop(0.2)
		area.destroy()
		queue_free()
		


func _on_body_entered(body: Node2D) -> void:
	$HitSFX.pitch_scale = randf_range(0.9, 1.1)
	$HitSFX.play()
	if body.is_in_group("player"):
		body.hit_flash_player.play("hit_flash")
		await get_parent().hit_stop(0.4)
		body.destroy()
		queue_free()
