extends Area2D

var bullet_speed := 300
var bullet_direction := -1


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position.y += bullet_speed * bullet_direction * delta


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("bullet"):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.destroy_player()
		queue_free()
