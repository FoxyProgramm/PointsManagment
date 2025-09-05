class_name CheatsHandler extends Node

@onready var codes:Dictionary[String, Callable] = {
	
}

var code:String = "00000000"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
			code = code.right(7) + OS.get_keycode_string(event.keycode)
			for key in codes.keys():
				if code.find(key) != -1:
					codes[key].call()
					code = "00000000"
