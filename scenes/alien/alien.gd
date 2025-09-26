@icon("res://sprites/alien4.png")
class_name Alien extends Area2D

signal alien_destroyed
signal level_cleared

@export var alien_type := 1

var alien_sprites : Array[Texture] = [
	preload("res://sprites/Alien1.png"),
	preload("res://sprites/Alien2.png"),
	preload("res://sprites/Alien3.png"),
	]
	
var bullet := preload("res://scenes/bullet/bullet.tscn")
	
var alien_colors : Array[Color] = [Color("FFEC27"),Color("29ADFF"),Color("FF004D")]

var direction := 1

var column_group : int
var row_group : int
var exposed = false


func _ready() -> void:
	# connect signals
	$StepTimer.timeout.connect(_on_step_timer_timeout)
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)
	area_entered.connect(_on_area_entered)
	alien_destroyed.connect(get_parent().increase_score)
	level_cleared.connect(get_parent().level_cleared)
	%DestroySFX.finished.connect(func(): queue_free())
	
	# set style
	$Sprite2D.texture = alien_sprites[alien_type]
	modulate = alien_colors[alien_type]
	
	# initialise shooting
	if row_group == 4:
		exposed = true
		$ShootTimer.wait_time = randf_range(3.0, 10.0)
		$ShootTimer.start()


func _on_area_entered(area: Node2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		destroy_alien()


func change_direction() -> void:
	direction *= -1
	position.y += 8



func destroy_alien() -> void:
	GameManager.aliens_destroyed += 1
	GameManager.aliens_remaining -= 1
	alien_destroyed.emit(1 * GameManager.level)
	if exposed == true:
		get_tree().call_group("alien", "check_exposed", column_group, row_group)
	visible = false
	%DestroySFX.play()
	if GameManager.aliens_remaining == 0:
		level_cleared.emit()


func _on_step_timer_timeout() -> void:
	position.x += 8 * direction
	if $Sprite2D.frame == 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0


func _on_shoot_timer_timeout() -> void:
	var instance = bullet.instantiate()
	instance.position = Vector2(position.x, position.y + 21)
	instance.bullet_direction = 1
	add_sibling(instance)
	$ShootTimer.wait_time = randf_range(3.0, 10.0)
	$ShootTimer.start()


func check_exposed(column, row):
	if column_group == column:
		if row_group == row - 1:
			exposed = true
			$ShootTimer.start()
