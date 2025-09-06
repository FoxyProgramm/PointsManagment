class_name Buyer extends Node2D

var shop_list:Dictionary[Point, int] = {}
var shopping_cart:Dictionary[Point, int] = {}

var on_board:bool = false
@export_range(0.0, 2.0, 0.05) var delay:float = 0.5
@export_range(1.0, 10.0, 0.05) var speed_multiplier:float = 2.0

@export var buyer:Point
@export var linked_ship:Spaceship

func generate_shop_list() -> void:
	shop_list.clear()
	shopping_cart.clear()
	var new_list = Global.all_points.duplicate()
	new_list.shuffle()
	for point_ in new_list:
		var point :Point = point_
		var quantity:int = randi_range(1, 4)
		shop_list[point] = quantity
	
func delink_ship() -> void:
	linked_ship.arrive.disconnect(shopping)
	linked_ship.away.disconnect(hide)
	linked_ship.travel.disconnect(on_travel)
	if on_board:
		linked_ship.passengers_on_board -= 1
		on_board = false
	linked_ship.all_passengers -= 1
	
	linked_ship = null

func link_ship(ship:Spaceship) -> void:
	linked_ship = ship
	on_board = false
	
	linked_ship.arrive.connect(shopping)
	linked_ship.away.connect(hide)
	linked_ship.travel.connect(on_travel)
	linked_ship.all_passengers += 1
	self.global_position = linked_ship.global_position

func on_travel() -> void:
	on_board = false
	hide()

func _ready() -> void:
	link_ship($"../../Spaceships/Spaceship")
	if !Global.is_ready:
		await Global.final_ready
	generate_shop_list()

func complain_for_lack_of_points(point:Point) -> void:
	print("There no points like: ", point.name)

func shopping() -> void:
	show()
	for point in shop_list:
		await get_tree().create_timer(delay).timeout
		var storage := Global.points_manager.get_storage_by_points(point, true, true, false, true)
		if storage:
			shopping_cart[point] = 0
			
			var tween := create_tween()
			tween.tween_property(self, "global_position", storage.global_position, Global.get_walk_time_by_distance(global_position.distance_to(storage.global_position), speed_multiplier)).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
			var wait_for_circle := true
			while shopping_cart[point] < shop_list[point]:
				if storage.remove_point():
					shopping_cart[point] += 1
					queue_redraw()
					Global.money += 1
					await get_tree().create_timer(0.1).timeout
				else :
					if wait_for_circle:
						wait_for_circle = false
						await get_tree().create_timer(3.0).timeout
						storage = Global.points_manager.get_storage_by_points(point, true, true, false, true)
						if storage: continue
					
					complain_for_lack_of_points(point)
					break
		else :
			complain_for_lack_of_points(point)
	
	var tween_ := create_tween()
	tween_.tween_property(self, "global_position", linked_ship.global_position, Global.get_walk_time_by_distance(global_position.distance_to(linked_ship.global_position), speed_multiplier)).set_trans(Tween.TRANS_CUBIC)
	await tween_.finished
	
	linked_ship.passengers_on_board += 1
	on_board = true
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, buyer.radius, buyer.color, true, -1, true)
	var height = -buyer.radius
	for point in shopping_cart:
		for i in range( shopping_cart[point] ):
			draw_circle(Vector2(0, height), point.radius, point.color, true, -1, true)
			height -= point.radius/2
