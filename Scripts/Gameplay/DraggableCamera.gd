extends Camera2D

var move_to:Vector2
var zoom_to:=Vector2.ONE

var drag:bool = false
var first_pos:Vector2

func _process(delta: float) -> void:
	var weight:float = min(delta*16, 1)
	if drag:
		move_to = global_position + (first_pos - get_global_mouse_position())
	global_position = global_position.lerp(move_to, weight)
	zoom = zoom.lerp( zoom_to, weight )

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_drag"):
		first_pos = get_global_mouse_position()
		drag = true
	elif event.is_action_released("start_drag"):
		drag = false
	
	if event.is_action_pressed("zoom_in"):
		zoom_to *= 1.1
		move_to = move_to.lerp(get_global_mouse_position(), 0.1)
		
	elif event.is_action_pressed("zoom_out"):
		zoom_to *= 0.9
		move_to = move_to.lerp(get_global_mouse_position(), -0.1)
