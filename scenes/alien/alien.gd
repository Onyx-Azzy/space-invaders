extends Area2D

signal alien_destroyed
signal level_cleared

@export var alien_type := 1

var alien_sprites : Array[Texture] = [
	preload("res://sprites/Alien1.png"),
	preload("res://sprites/Alien2.png"),
	preload("res://sprites/Alien3.png"),
	]
	
var bullet := preload("res://scenes/bullet/bullet.tscn")
var explosion := preload("res://scenes/player/explosion.tscn")

@onready var hit_flash_player: AnimationPlayer = $HitFlashPlayer

	
var alien_colors : Array[Color] = [Color("FFEC27"),Color("29ADFF"),Color("FF004D")]

var direction := 1

var column_group : int
var row_group : int
var exposed = false


func _ready() -> void:
	# connect signals
	$ShootTimer.timeout.connect(_on_shoot_timer_timeout)
	alien_destroyed.connect(get_parent().alien_destroyed)
	level_cleared.connect(get_parent().level_cleared)
	hit_flash_player.animation_finished.connect(func(_anim_name: StringName): explosion_fx(); queue_free())
	area_entered.connect(_on_area_entered)
	
	# set style
	$Sprite2D.texture = alien_sprites[alien_type]
	modulate = alien_colors[alien_type]
	
	# initialise shooting
	if row_group == 4:
		exposed = true
		$ShootTimer.wait_time = randf_range(2.0, 15.0)
		$ShootTimer.start()


# movement
func step() -> void:
	position.x += 8 * direction
	if $Sprite2D.frame == 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0


func change_direction() -> void:
	direction *= -1
	position.y += 8


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		get_parent().screen_shake(0.1)
		hit_flash_player.play("hit_flash")
		await get_parent().hit_stop(0.3)
		destroy()


# death
func destroy() -> void:
	GameManager.aliens_destroyed += 1
	GameManager.aliens_remaining -= 1
	alien_destroyed.emit(column_group, self)	
	if exposed == true:
		get_tree().call_group("alien", "check_exposed", column_group)
	visible = false
	
	if GameManager.aliens_remaining == 0:
		level_cleared.emit()


# shooting
func _on_shoot_timer_timeout() -> void:
	var instance = bullet.instantiate()
	instance.position = Vector2(position.x, position.y + 21)
	instance.bullet_direction = 1
	add_sibling(instance)
	$ShootTimer.wait_time = randf_range(5.0, 15.0)
	$ShootTimer.start()
	$ShootSFX.pitch_scale = randf_range(1.1, 1.2)
	$ShootSFX.play()


func check_exposed(column):
	if column_group == column:
		if self == get_parent().alien_column_groups[column].back():
			exposed = true
			$ShootTimer.start()


func explosion_fx() -> void:
	# instantiate exposion particles
	var instance = explosion.instantiate()
	instance.position = position
	instance.pitch_scale = randf_range(0.95, 1.05)
	add_sibling(instance)
