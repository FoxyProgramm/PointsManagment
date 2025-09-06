class_name Spaceship extends Node2D

var all_passengers:int = 0
var passengers_on_board:int = 0 :
	set(value) :
		passengers_on_board = value
		if all_passengers == 0 : return
		if passengers_on_board == all_passengers:
			passengers_on_board = 0
			toggle_arrive(false)

@warning_ignore("unused_signal")
signal arrive
signal travel
@warning_ignore("unused_signal")
signal away

enum STATES{ARRIVED, TRAVEL, AWAY}
var state:STATES

var centered_rect:Rect2

@export var size := Vector2(100, 100)
@export var color_theme:BoxColor

var arrive_linear:float = 0.0 :
	set(value):
		arrive_linear = value
		update_arriving()

var arrive_tween:Tween

func toggle_arrive(state_:bool) -> bool:
	if state == STATES.TRAVEL: return false
	travel.emit()
	state = STATES.TRAVEL
	if arrive_tween and arrive_tween.is_running(): arrive_tween.kill()
	arrive_tween = create_tween()
	arrive_tween.tween_property(self, "arrive_linear", ( 1 if state_ else 0 ), 3.0 ).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await arrive_tween.finished
	state = STATES.ARRIVED if state_ else STATES.AWAY
	emit_signal("arrive" if state_ else "away")
	return true

func update_arriving() -> void:
	self.modulate.a = arrive_linear
	self.scale = Vector2.ONE + Vector2.ONE * (1.0-arrive_linear)
	self.rotation = 1.571 * arrive_linear

func _ready() -> void:
	update_arriving()
	centered_rect = Rect2( -size/2, size )
	await get_tree().create_timer(2).timeout
	print(await toggle_arrive(true))

func _draw() -> void:
	draw_rect(centered_rect, color_theme.color )
	draw_rect(centered_rect, color_theme.outline, false, color_theme.outline_width, true)
