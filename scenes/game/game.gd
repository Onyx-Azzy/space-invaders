extends Node2D

@onready var player: PackedScene = preload("res://scenes/player/player.tscn")
@onready var alien: PackedScene = preload("res://scenes/alien/alien.tscn")

var alien_type_order : Array[int] = [2, 1, 1, 0, 0]


func _ready() -> void:
	$Arena/Wall.area_entered.connect(_on_wall_area_entered)
	$Arena/Wall2.area_entered.connect(_on_wall_area_entered)
	$Timer.timeout.connect(_on_timer_timeout)
	GameManager.score = 0
	start_game()


func start_game() -> void:
	GameManager.score = 0
	GameManager.aliens_destroyed = 0
	GameManager.aliens_remaining = 0
	GameManager.lives = 3
	GameManager.level = 1
	spawn_player()
	spawn_aliens()


func spawn_player() -> void:
	var instance = player.instantiate()
	instance.position = Vector2(480, 488)
	add_child(instance)


func spawn_aliens() -> void:
	var number_of_columns = 11
	var number_of_rows = 5
	var start_pos_x = 64
	var pos_x = start_pos_x
	var pos_y = 88
	for row in number_of_rows:
		for column in number_of_columns:
			var instance = alien.instantiate()
			instance.alien_type = alien_type_order[row]
			instance.column_group = column
			instance.row_group = row
			instance.position = Vector2(pos_x, pos_y)
			add_child(instance)
			GameManager.aliens_remaining += 1
			pos_x += 48
		pos_x = start_pos_x
		pos_y += 32


func _on_wall_area_entered(area: Node2D) -> void:
	if area.is_in_group("alien"):
		$Timer.start()


func _on_timer_timeout() -> void:
	get_tree().call_group("alien", "change_direction")


func increase_score() -> void:
	GameManager.score += 1 * GameManager.level
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
