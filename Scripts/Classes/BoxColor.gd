class_name BoxColor extends Resource
var color:Color
var outline:Color
var outline_width:float = 2.0
static func create(color_:Color, outline_:Color, outline_width_:float = 2.0) -> BoxColor:
	var result := BoxColor.new()
	result.color = color_
	result.outline = outline_
	result.outline_width = outline_width_
	return result
