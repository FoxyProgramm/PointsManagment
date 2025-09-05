class_name PointsDeliver extends Node2D

enum STATES{IDLE, DELIVERING}
var state:STATES = STATES.IDLE

signal finish_delivering(succsess:bool)

@export_range(1, 10, 1) var max_delivered_points:int = 1

@export_range(1.0, 10, 0.01) var speed:float = 2.0
@export_range(0.05, 1.0, 0.01) var pick_up_time:float = 0.1

@export var display_radius:float = 25.0
@export var display_color:Color = Color.WEB_GRAY

var delivered_res:Point = null
var delivered_points:int = 0 :
	set(value):
		delivered_points = value
		queue_redraw()
		
func take_point(storage:PointsStorage) -> void:
	while delivered_points < max_delivered_points:
		if storage.remove_point():
			delivered_points += 1
			await get_tree().create_timer(0.1).timeout
		else :
			break

func give_point(storage:PointsStorage) -> void:
	while delivered_points > 0:
		if storage.add_point():
			delivered_points -= 1
			await get_tree().create_timer(0.1).timeout
		else :
			break

func move_points() -> void:
	var skip_pick_up:bool = false
	var to : PointsStorage
	if delivered_points > 0:
		to = Global.points_manager.get_storage_by_points(delivered_res, true, false, true, false)
		if !to:
			to = Global.points_manager.get_storage_by_points(null, true, false, true, false)
			if to:
				var return_to := Global.points_manager.get_storage_by_points(delivered_res, false, false, true, false)
				if return_to:
					var sub_tween : Tween
					sub_tween = create_tween()
					
					sub_tween.tween_property(self, "global_position", return_to.global_position, self.global_position.distance_to(return_to.global_position)/(speed*100) ).set_trans(Tween.TRANS_CUBIC)
					await sub_tween.finished
					await give_point(return_to)
				
				delivered_points = 0
		else :
			skip_pick_up = true
	else :
		to = Global.points_manager.get_storage_by_points(null, true, false, true, false)
	if !to:
		await get_tree().create_timer(0.1).timeout
		finish_delivering.emit(false)
		return
	delivered_res = to.point_res
	var from : PointsStorage
	
	if !skip_pick_up:
		from = Global.points_manager.get_storage_by_points(to.point_res, false, true, false, true)
		
		if !from:
			await get_tree().create_timer(0.1).timeout
			finish_delivering.emit(false)
			return
	
	var tween : Tween
	
	if !skip_pick_up:
		tween = create_tween()
		tween.tween_property(self, "global_position", from.global_position, self.global_position.distance_to(from.global_position)/(speed*100) ).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		await take_point(from)
	tween = create_tween()
	tween.tween_property(self, "global_position", to.global_position, self.global_position.distance_to(to.global_position)/(speed*100) ).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	await give_point(to)
	finish_delivering.emit(true)

func work_cycle() -> void:
	while true:
		state = STATES.DELIVERING
		move_points()
		var result :bool= await finish_delivering
		print("result of work, ", result)
		if !result:
			state = STATES.IDLE
			print("start idle")
			break

func resume_work() -> void:
	if state == STATES.DELIVERING: return
	work_cycle()

func _ready() -> void:
	if !Global.is_ready:
		await Global.final_ready
	Global.points_manager.points_changed.connect(resume_work)
	work_cycle()

func _draw() -> void:
	draw_circle(Vector2(0,0), display_radius, display_color, true, -1, true)
	
	for i in range(delivered_points) :
		draw_circle(Vector2(0, -(i * delivered_res.radius / 2)-display_radius ), delivered_res.radius, delivered_res.color, true, -1, true)
