class_name Boxes extends Node2D

@export_range(0.0, 25.0, 0.1) var padding:float = 10.0

@export var color:=Color.ORANGE
@export var outline:=Color.CHOCOLATE
@export_range(0.0, 10.0, 0.1) var outline_width:float = 2.0

var boxes:Array[Rect2] = []

func _draw() -> void:
	for box in boxes:
		var c_box = box.grow(padding)
		draw_rect(c_box, color)
		draw_rect(c_box, outline, false, outline_width, true)
