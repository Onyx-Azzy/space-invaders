extends GPUParticles2D

var pitch_scale := 1.0

@onready var explosion_sfx: AudioStreamPlayer = $ExplosionSFX


func _ready() -> void:
	explosion_sfx.finished.connect(func(): queue_free())
	explosion_sfx.pitch_scale = pitch_scale
	explosion_sfx.play()
	restart()
