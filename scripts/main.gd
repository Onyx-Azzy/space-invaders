extends Node

signal alien_change_direction
signal alien_exposed_destroyed(col, row)

var player = preload("res://scenes/player.tscn")
var alien = preload("res://scenes/alien.tscn")
var mothership = preload("res://scenes/mothership.tscn")

var bullet_count

var score
var player_lives


func new_game():
	$UI/StartButton.visible = false
	$UI/QuitButton.visible = false
	$UI/GameOverText.visible = false
	bullet_count = 0
	score = 0
	player_lives = 3
	update_score(0)
	update_lives(player_lives)
	spawn_player()
	spawn_aliens()
	$MothershipSpawner.start()
	$UI/Score.visible = true


func spawn_player():
	var player_instance = player.instantiate()
	player_instance.position = Vector2(87,160)
	add_child(player_instance)


func spawn_aliens():
	var alien_width = 11 # alien width
	var alien_height = 11 # alien height
	var alien_spacing = 2 # Space between aliens
	var rows = 5 # Number of rows
	var cols = 11 # Number of columns

	for row in range(rows):
		for col in range(cols):
			var alien_instance = alien.instantiate() # Instantiate alien scene

			var x_pos = 13 + (col * (alien_width + alien_spacing) + alien_width / 2)
			var y_pos = 26 + (row * (alien_height + alien_spacing) + alien_height / 2)
			
			alien_instance.position = Vector2(x_pos, y_pos)
			alien_instance.row_group = row
			alien_instance.column_group = col
			if row == 0:
				alien_instance.alien_type = 0
			elif row <= 2:
				alien_instance.alien_type = 1
			if row == 3:
				alien_instance.alien_type = 2
			elif row == 4: 
				alien_instance.alien_type = 2
				alien_instance.exposed = true
				
			connect("alien_change_direction", alien_instance.alien_change_direction)
			connect("alien_exposed_destroyed", alien_instance.check_exposed)
			
			add_child(alien_instance) # Add to main scene


func _on_mothership_spawner_timeout() -> void:
	var pick_direction = [-1, 1]
	var direction = pick_direction.pick_random()
	
	var mothership_instance = mothership.instantiate()
	
	mothership_instance.direction = direction

	if direction == -1:
		mothership_instance.position = Vector2(190, 16)
	else:
		mothership_instance.position = Vector2(-10, 16)
		
	add_child(mothership_instance)
	
	$MothershipSpawner.wait_time = randf_range(10, 15)
	$MothershipSpawner.start()


func alien_destroyed(col, row, exposed):
	if exposed == true:
		alien_exposed_destroyed.emit(col, row)
	if row == 0:
		update_score(30)
	elif row < 3:
		update_score(20)
	elif row < 5:
		update_score(10)


func mothership_destroyed():
	update_score(100)


func update_score(points):
	score += points
	$UI/Score.text = str(score)


func update_lives(lives):
	for i in $UI/Lives.get_child_count():
		$UI/Lives.get_child(i).visible = lives > i


func _on_alien_wall_left_body_entered(body: Node2D) -> void:
	alien_change_direction.emit()


func _on_alien_wall_right_body_entered(body: Node2D) -> void:
	alien_change_direction.emit()


func player_destroyed() -> void:
	if player_lives == 0:
		end_game()
	else:
		player_lives += -1
		update_lives(player_lives)
		$RespawnTimer.start()


func end_game():
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("aliens", "queue_free")
	$MothershipSpawner.stop()
	$UI/Score.visible = false
	$UI/GameOverText.visible = true
	$UI/StartButton.visible = true
	$UI/QuitButton.visible = true


func _on_respawn_timer_timeout() -> void:
	spawn_player()


func _on_start_button_pressed() -> void:
	new_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
