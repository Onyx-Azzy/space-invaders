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
	
var alien_colors : Array[Color] = [Color("FFEC27"),Color("29ADFF"),Color("FF004D")]

var direction := 1


func _ready() -> void:
	# connect signals
	$Timer.timeout.connect(_on_timer_timeout)
	area_entered.connect(_on_area_entered)
	alien_destroyed.connect(get_parent().increase_score)
	level_cleared.connect(get_parent().level_cleared)
	%DestroySFX.finished.connect(func(): queue_free())
	
	# set style
	$Sprite2D.texture = alien_sprites[alien_type]
	modulate = alien_colors[alien_type]


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
	alien_destroyed.emit()
	visible = false
	%DestroySFX.play()
	if GameManager.aliens_remaining == 0:
		level_cleared.emit()


func _on_timer_timeout() -> void:
	position.x += 8 * direction
	if $Sprite2D.frame == 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
