extends Button


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_mouse_pressed)


func _on_mouse_entered() -> void:
	material.set_shader_parameter("strength", 1)
	var tween = create_tween()
	%RollOverSFX.play()
	tween.tween_property(self, "custom_minimum_size", Vector2(160, 70), 0.2)



func _on_mouse_exited() -> void:
	material.set_shader_parameter("strength", 0)
	var tween = create_tween()
	tween.tween_property(self, "custom_minimum_size", Vector2(150, 60), 0.2)


func _on_mouse_pressed() -> void:
	%ClickSFX.play()
