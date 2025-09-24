extends Area2D

var bullet_speed := 500
var bullet_direction := -1


func _physics_process(delta: float) -> void:
	position.y += bullet_speed * bullet_direction * delta
