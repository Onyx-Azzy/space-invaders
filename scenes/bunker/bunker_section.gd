extends Area2D

@export var sprite_frame := 0


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$Sprite2D.frame = sprite_frame


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("bullet"):
		get_parent().bunker_hit()
		area.queue_free()
		queue_free()
