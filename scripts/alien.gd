extends CharacterBody2D

signal alien_destroyed(column, row, exposed)

var alien_types = [
	preload("res://sprites/Alien1.png")
	, preload("res://sprites/Alien2.png")
	, preload("res://sprites/Alien3.png")
]
var alien_type

var bullet = preload("res://scenes/bullet.tscn")

var alien_speed

var main

var step_direction
var row_group
var column_group
var exposed = false 

func _ready():
	$Sprite2D.texture = alien_types[alien_type]
	main = get_parent()
	step_direction = 1.0
	$Shoot.wait_time = randf_range(1.0, 3.0)
	connect("alien_destroyed", get_parent().alien_destroyed)
	if exposed == true:
		$Shoot.start()


func _on_timer_timeout() -> void:
	position.x += step_direction
	if $Sprite2D.frame == 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
		
func alien_change_direction():
	$ChangeDirection.start()


func _on_change_direction_timeout() -> void:
	step_direction = step_direction * -1
	position.y += 5


func _on_shoot_timeout() -> void:
	if main.bullet_count == 0:
		var bullet_instance = bullet.instantiate()
		bullet_instance.position = Vector2(position.x, position.y +7)
		bullet_instance.bullet_direction = 1
		bullet_instance.parent = main
		add_sibling(bullet_instance)
		$Shoot.wait_time = randf_range(2.0, 3.0)
		
func destroy():
	alien_destroyed.emit(column_group, row_group, exposed)
	queue_free()

func check_exposed(col, row):
	if col == column_group:
		if row - 1 == row_group:
			exposed = true
			$Shoot.start()
