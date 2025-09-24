extends Control

var index_sounds_bus := AudioServer.get_bus_index("Sounds")

var paused := false


func _ready() -> void:
	%ContinueButton.pressed.connect(toggle_pause)
	%RestartButton.pressed.connect(restart)
	%SettingsButton.pressed.connect(show_settings)
	%MenuButton.pressed.connect(quit_to_menu)
	
	%HideSettingsButton.pressed.connect(hide_settings)
	%SoundsHSlider.value_changed.connect(sfx_volume_changed)
	
	%SoundsHSlider.value = db_to_linear(AudioServer.get_bus_volume_db(index_sounds_bus))



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


func update_score() -> void:
	%ScoreLabel.text = str(GameManager.score)


func update_highscore() -> void:
	%HighscoreLabel.text = "Highscore: " + str(GameManager.save_data.high_score)


func update_lives() -> void:
	%BallIndicatorLabel.text = str(GameManager.lives)


func toggle_pause()-> void:
	if paused:
		paused = not paused
		get_tree().paused = not get_tree().paused
		%GameMenu.hide()
		%SettingsMenu.hide()
	elif not paused:
		paused = not paused
		get_tree().paused = not get_tree().paused
		%GameMenu.show()


func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func show_settings() -> void:
	%SettingsMenu.show()
	%GameMenu.hide()


func hide_settings() -> void:
	%SettingsMenu.hide()
	%GameMenu.show()


func sfx_volume_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(index_sounds_bus, linear_to_db(new_value))


func quit_to_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func game_over() -> void:
	%GameOverLabel.show()
	%HighscoreLabel.show()
	%GameMenu.show()
	%RestartButton.show()
	%MenuButton.show()
	%SettingsButton.hide()
	%ContinueButton.hide()
