@icon("res://sprites/player.png")
class_name Player extends CharacterBody2D

signal player_destroyed

const SPEED := 500.0

var acceleration := 10.0
var deceleration := 30.0

var bullet := preload("res://scenes/bullet/bullet.tscn")

var shooting := false


func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	player_destroyed.connect(get_parent().player_destroyed)


func _physics_process(delta: float) -> void:
	## player input
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, deceleration * delta)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action("action") and not shooting:
		fire_bullet()


func fire_bullet() -> void:
	var instance = bullet.instantiate()
	instance.position = Vector2(position.x, position.y - 16)
	add_sibling(instance)
	shooting = true
	$Timer.start()


func _on_timer_timeout() -> void:
	shooting = false


func destroy_player() -> void:
	player_destroyed.emit()
	queue_free()
