extends Node2D

@onready var player: PackedScene = preload("res://scenes/player/player.tscn")
@onready var alien: PackedScene = preload("res://scenes/alien/alien.tscn")
@onready var mothership: PackedScene = preload("res://scenes/alien/mothership.tscn")
@onready var step_sfx: Array[AudioStream] = [
						preload("res://sfx/fastinvader1.wav"),
						preload("res://sfx/fastinvader2.wav"),
						preload("res://sfx/fastinvader3.wav"),
						preload("res://sfx/fastinvader4.wav"),
								]

var current_step_sfx = 3

var alien_type_order : Array[int] = [2, 1, 1, 0, 0]

@onready var alien_column_groups : Array[Array] = [[],[],[],[],[],[],[],[],[],[],[]]

func _ready() -> void:
	$Arena/Wall.area_entered.connect(_on_wall_area_entered)
	$Arena/Wall2.area_entered.connect(_on_wall_area_entered)
	$StepTimer.timeout.connect(_on_step_timer_timeout)
	$ChangeDirectionTimer.timeout.connect(_on_change_direction_timer_timeout)
	$MothershipTimer.timeout.connect(_on_mothership_timer_timeout)
	
	start_game()


func start_game() -> void:
	GameManager.score = 0
	GameManager.aliens_destroyed = 0
	GameManager.aliens_remaining = 0
	GameManager.lives = 3
	GameManager.level = 1
	
	spawn_player()
	spawn_aliens()
	
	$MothershipTimer.wait_time = randf_range(15,30)
	$MothershipTimer.start()


func spawn_player() -> void:
	var instance = player.instantiate()
	instance.position = Vector2(480, 488)
	add_child(instance)


func spawn_aliens() -> void:
	$StepTimer.stop()
	var number_of_columns = 11
	var number_of_rows = 5
	var start_pos_x = 64
	var pos_x = start_pos_x
	var pos_y = 88
	for row in number_of_rows:
		for column in number_of_columns:
			var instance = alien.instantiate()
			instance.alien_type = alien_type_order[row]
			alien_column_groups[column].append(instance)
			instance.column_group = column
			instance.row_group = row
			instance.position = Vector2(pos_x, pos_y)
			add_child(instance)
			GameManager.aliens_remaining += 1
			pos_x += 48
		pos_x = start_pos_x
		pos_y += 32
	$StepTimer.wait_time = GameManager.aliens_remaining * 0.02
	$StepTimer.start()


func _on_wall_area_entered(area: Node2D) -> void:
	if area.is_in_group("alien"):
		$ChangeDirectionTimer.start()


func _on_step_timer_timeout() -> void:
	get_tree().call_group("alien", "step")
	$StepSFX.stream = step_sfx[current_step_sfx]
	$StepSFX.play()
	current_step_sfx += 1
	if current_step_sfx == 4:
		current_step_sfx = 0
	$StepTimer.wait_time = GameManager.aliens_remaining * 0.02


func _on_change_direction_timer_timeout() -> void:
	get_tree().call_group("alien", "change_direction")


func _on_mothership_timer_timeout() -> void:
	var instance = mothership.instantiate()
	var random_position = randi_range(1, 2)
	if random_position == 1:
		instance.position = Vector2(-40, 40)
		instance.direction = 1
	else:
		instance.position = Vector2(1000, 40)
		instance.direction = -1
	add_child(instance)
	$MothershipTimer.wait_time = randf_range(20,45)


func alien_destroyed(column, alien) -> void:
	alien_column_groups[column].erase(alien)
	increase_score(1 * GameManager.level)


func increase_score(amount: int) -> void:
	GameManager.score += amount
	%UI.update_score()


func player_destroyed() -> void:
	GameManager.lives -= 1
	%UI.update_lives()
	await get_tree().create_timer(2.0).timeout
	if GameManager.lives > 0:
		spawn_player()
	else:
		game_over()


func level_cleared() -> void:
	GameManager.level += 1
	await get_tree().create_timer(1.0).timeout
	spawn_aliens()


func game_over() -> void:
	if GameManager.score > GameManager.save_data.high_score:
		GameManager.save_data.high_score = GameManager.score
		GameManager.save_data.save()
	%UI.update_highscore()
	%UI.game_over()


func hit_stop(duration: float) -> void:
	Engine.time_scale = 0.0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0


func screen_shake(amount: float) -> void:
	$Camera2D.add_trauma(amount)
