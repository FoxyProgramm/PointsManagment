extends Node

signal final_ready
var is_ready:bool = false

var points_manager:PointsManager

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	final_ready.emit()
	is_ready = true
