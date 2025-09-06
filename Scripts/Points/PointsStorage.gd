class_name PointsStorage extends Node2D

@export var sellable:bool = false

@export_range(0, 400) var points:int :
	set(value):
		points = value
		if !Global.is_ready:
			await Global.final_ready
		Global.points_manager.points_changed.emit()
		queue_redraw()

@export_range(1, 20) var max_columns:int = 3
@export_range(1, 20) var max_rows:int = 3

@export_range(0.0, 50.0, 0.1) var space_between:float = 5.0

@export var point_res:Point

var max_points_count: int = 0
var state:PointsManager.STORAGE_STATES = 0
var can_place:bool = false :
	set(state):
		if state != can_place:
			can_place = state
			queue_redraw()

func _ready() -> void:
	global_position = (global_position / Global.grid).floor() * Global.grid
	max_points_count = max_columns * max_rows
	if points > max_points_count: points = max_points_count

func change_points_to(value:int) -> void:
	points = clamp(value, 0, max_points_count)

func add_point() -> bool:
	if points == max_points_count: return false
	points += 1
	return true

func remove_point() -> bool:
	if points == 0: return false
	points -= 1
	return true

func get_points_to_fill() -> int:
	return max_points_count - points

func get_max_size() -> Vector2:
	return Vector2(
		(max_columns * point_res.radius * 2) + ( (max_columns - 1) * space_between ),
		(max_rows * point_res.radius * 2) + ( (max_rows - 1) * space_between ),
	 )

func get_global_rect() -> Rect2:
	return Rect2( global_position - Vector2(point_res.radius, point_res.radius), get_max_size() )

func get_local_rect() -> Rect2:
	return Rect2( -Vector2(point_res.radius, point_res.radius), get_max_size() )

func _draw() -> void:
	var box_sizes = get_local_rect().grow(Global.points_manager.storage_box_padding)
	var box_style:BoxColor
	match state:
		PointsManager.STORAGE_STATES.STATIC:
			box_style = Global.points_manager.box_color_static
		PointsManager.STORAGE_STATES.SELECTED:
			box_style = Global.points_manager.box_color_selected
		PointsManager.STORAGE_STATES.MOVE:
			if can_place:
				box_style = Global.points_manager.box_color_can_move
			else :
				box_style = Global.points_manager.box_color_cant_move
	
	draw_rect(box_sizes, box_style.color)
	draw_rect(box_sizes, box_style.outline, false, box_style.outline_width, true)
	
	if !points: return
	var idx:int = 0
	for row in range(max_rows):
		for col in range(max_columns):
			draw_circle( Vector2(col*(point_res.radius*2+ space_between), row*(point_res.radius*2 + space_between)), point_res.radius, point_res.color, true, -1, true )
			idx += 1
			if idx == points : return

	
