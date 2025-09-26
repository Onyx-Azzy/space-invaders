extends Area2D

signal mothership_destroyed(amount: int)

const SPEED = 100
var direction := -1


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	mothership_destroyed.connect(get_parent().increase_score)


func _physics_process(delta: float) -> void:
	position.x += SPEED * direction * delta


func _on_area_entered(area: Node2D) -> void:
	mothership_destroyed.emit(50 * GameManager.level)
	area.queue_free()
	queue_free()
