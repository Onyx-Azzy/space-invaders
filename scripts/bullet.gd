extends Area2D

var bullet_speed = 100
var bullet_direction = -1

var parent


func _ready() -> void:
	parent.bullet_count += 1


func _process(delta: float) -> void:
	position.y += bullet_speed * bullet_direction * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		destroy()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		destroy()
		body.destroy()
		
	if body.is_in_group("aliens"):
		destroy()
		body.destroy()


func destroy():
	parent.bullet_count -= 1
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	destroy()
