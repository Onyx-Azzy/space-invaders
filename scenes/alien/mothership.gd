extends Area2D

signal mothership_destroyed(amount: int)

var explosion := preload("res://scenes/player/explosion.tscn")

@onready var hit_flash_player: AnimationPlayer = $HitFlashPlayer

const SPEED = 100
var direction := -1

var moving = true


func _ready() -> void:
	# connect signals
	mothership_destroyed.connect(get_parent().increase_score)
	hit_flash_player.animation_finished.connect(func(_anim_name: StringName): explosion_fx(); queue_free())
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)
	area_entered.connect(_on_area_entered)
	


func _process(delta: float) -> void:
	if not moving:
		return
		
	# move the ship across the screen
	position.x += SPEED * direction * delta
	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		moving = false
		get_parent().screen_shake(0.2)
		hit_flash_player.play("hit_flash")
		await get_tree().create_timer(0.3, true, false, true).timeout
		destroy()


func destroy() -> void:
	$destroy_sfx.play()

	# increase score
	mothership_destroyed.emit(50 * GameManager.level)


func explosion_fx() -> void:
	# instantiate exposion particles
	var instance = explosion.instantiate()
	instance.position = position
	instance.pitch_scale = randf_range(0.85, 0.9)
	add_sibling(instance)


func _on_screen_exited() -> void:
	queue_free()
