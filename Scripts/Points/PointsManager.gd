class_name PointsManager extends Node2D

enum STORAGE_STATES{STATIC, SELECTED, MOVE}
enum EMPTY_TYPES{EMPTY, PARTICALY_FULL, FULL}

signal points_changed

var can_pressed:bool = false

var active_storage:PointsStorage

@export_range(0.0, 25.0, 0.1) var storage_box_padding:float = 10.0

func _ready() -> void:
	Global.points_manager = self

var box_color_static = BoxColor.create( Color(0.153, 0.153, 0.153, 0.4), Color(0.111, 0.111, 0.111, 1.0) )
var box_color_selected = BoxColor.create( Color(1.0, 0.635, 0.11, 0.4), Color(1.0, 0.839, 0.0, 1.0) )
var box_color_can_move = BoxColor.create( Color(0.447, 0.851, 0.306, 0.4), Color(0.421, 0.7, 0.243, 1.0) )
var box_color_cant_move = BoxColor.create( Color(0.839, 0.237, 0.302, 0.4), Color(0.799, 0.054, 0.218, 1.0) )

func check_click_in_storage() -> void:
	for storage:PointsStorage in $Storages.get_children():
		if storage.get_global_rect().has_point( get_global_mouse_position()):
			if active_storage:
				active_storage.state = STORAGE_STATES.STATIC
				active_storage.queue_redraw()
			active_storage = storage
			storage.state = STORAGE_STATES.SELECTED
			storage.queue_redraw()
			return
	if active_storage:
		active_storage.state = STORAGE_STATES.STATIC
		active_storage.queue_redraw()
		active_storage = null
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_drag"):
		can_pressed = true
	elif event.is_action_released("start_drag") and can_pressed:
		check_click_in_storage()
	if event is InputEventMouseMotion:
		can_pressed = false
		
	if event.is_action_pressed("plus_point") and active_storage:
		active_storage.add_point()
	elif event.is_action_pressed("minus_point") and active_storage:
		active_storage.remove_point()

func get_storage_by_points(specific_res:Point = null, is_sell:bool = false, find_max_points:bool = true, deny_full:bool = false, deny_emply:bool = false) -> PointsStorage:
	var list:Dictionary[int, PointsStorage] = {}
	for child:PointsStorage in $Storages.get_children():
		if child.sellable == is_sell:
			
			if deny_full and child.points == child.max_points_count: continue
			if deny_emply and child.points == 0: continue
			
			if specific_res:
				if child.point_res == specific_res:
					list[child.points] = child
			else :
				list[child.points] = child
	if list.is_empty():
		return null
			
	if find_max_points:
		return list[list.keys().max()]
	else :
		return list[list.keys().min()]

func get_storage_by_emptiness(type:EMPTY_TYPES) -> PointsStorage:
	for child:PointsStorage in $Storages.get_children():
		match type:
			EMPTY_TYPES.EMPTY:
				if child.points == 0:
					return child
			EMPTY_TYPES.PARTICALY_FULL:
				if child.points > 0 and child.points < child.max_points_count:
					return child
			EMPTY_TYPES.FULL:
				if child.points == child.max_points_count:
					return child
	return null
