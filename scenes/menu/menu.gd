extends Control

var index_sounds_bus := AudioServer.get_bus_index("Sounds")

func _ready() -> void:
	%PlayButton.pressed.connect(play_game)
	%SettingsButton.pressed.connect(show_settings)
	%CreditsButton.pressed.connect(display_credits)
	%QuitButton.pressed.connect(quit_game)
	%ShowMenuButton.pressed.connect(show_menu)
	%SoundsHSlider.value_changed.connect(sfx_volume_changed)
	
	%SoundsHSlider.value = db_to_linear(AudioServer.get_bus_volume_db(index_sounds_bus))



func play_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")


func show_settings() -> void:
	%MainMenu.visible = false
	%SettingsMenu.visible = true
	%ShowMenuButton.visible = true


func display_credits() -> void:
	%MainMenu.visible = false
	%CreditsLabel.visible = true
	%ShowMenuButton.visible = true
	%Title.hide()


func quit_game() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()


func show_menu() -> void:
	%MainMenu.visible = true
	%CreditsLabel.visible = false
	%ShowMenuButton.visible = false
	%SettingsMenu.visible = false
	%Title.show()


func sfx_volume_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(index_sounds_bus, linear_to_db(new_value))
