extends Node

var textures:Dictionary[String, ImageTexture] = {}

signal final_ready
var is_ready:bool = false

var all_points:Array[Point] = []

var points_manager:PointsManager
var ui:UI

var grid:float = 30

var money:int = 0 :
	set(value) :
		money = value
		ui.draw_money()

func _ready() -> void:
	var save_points:PointsSave = load("res://Resources/Points.tres")
	all_points = save_points.points
	var save_textures:TexturesSave = load("res://Resources/Textures.tres")
	textures = save_textures.textures
	await get_tree().create_timer(1.0).timeout
	final_ready.emit()
	is_ready = true


func get_walk_time_by_distance(dist:float, multiplier:float = 10.0) -> float:
	return dist / ( 100 * multiplier )
