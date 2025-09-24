extends CharacterBody2D

signal mothership_destroyed

const SPEED = 30.0
var direction


func _ready():
	velocity.x = direction
	connect("mothership_destroyed", get_parent().mothership_destroyed)


func _physics_process(delta: float) -> void:
	position.x += direction * SPEED * delta


func destroy():
	mothership_destroyed.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_animation_timer_timeout() -> void:
	if $Sprite2D.frame == 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
