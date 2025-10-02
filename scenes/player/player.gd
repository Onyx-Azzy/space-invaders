extends CharacterBody2D

signal player_destroyed

const SPEED := 500.0

const ACCELERATION := 10.0
const DECELARATION := 10.0

var bullet := preload("res://scenes/bullet/bullet.tscn")
var explosion := preload("res://scenes/player/explosion.tscn")

@onready var death_sfx: AudioStreamPlayer = $DeathSFX
@onready var hit_flash_player: AnimationPlayer = $HitFlashPlayer

var shooting := false
var destroyed := false

func _ready() -> void:
	$ShootTimer.timeout.connect(_on_timer_timeout)
	hit_flash_player.animation_finished.connect(func(anim_name: StringName): explosion_fx(); queue_free())
	player_destroyed.connect(get_parent().player_destroyed)


func _process(delta: float) -> void:
	if destroyed:
		return
	
	## player input
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELARATION * delta)

	move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action("action") and not shooting:
		fire_bullet()


func fire_bullet() -> void:
	var instance = bullet.instantiate()
	instance.position = Vector2(position.x, position.y - 17  )
	add_sibling(instance)
	shooting = true
	$ShootTimer.start()
	$ShootSFX.pitch_scale = randf_range(0.8, 0.9)
	$ShootSFX.play()


func _on_timer_timeout() -> void:
	shooting = false


func destroy() -> void:	
	# destroy player scene
	destroyed = true
	player_destroyed.emit()


func explosion_fx() -> void:
	# instantiate exposion particles
	var instance = explosion.instantiate()
	instance.position = position
	instance.pitch_scale = randf_range(0.8, 0.85)
	add_sibling(instance)
