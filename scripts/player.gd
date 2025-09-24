extends CharacterBody2D

signal player_destroyed

const SPEED = 100.0

var bullet = preload("res://scenes/bullet.tscn")

var bullet_count


func _ready():
	bullet_count = 0
	connect("player_destroyed", get_parent().player_destroyed)


func _process(delta: float) -> void:
	if Input.is_action_pressed("fire") && bullet_count == 0: 
		fire_bullet()


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func fire_bullet():
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = Vector2(position.x, position.y -7)
		bullet_instance.bullet_direction = -1
		bullet_instance.parent = self
		add_sibling(bullet_instance)


func destroy():
	player_destroyed.emit()
	queue_free()
