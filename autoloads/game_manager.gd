extends Node

var score := 0
var lives := 0
var aliens_destroyed := 0
var aliens_remaining := 0
var level := 0

var save_data : SaveData

func _ready() -> void:
	save_data = SaveData.load_or_create()
