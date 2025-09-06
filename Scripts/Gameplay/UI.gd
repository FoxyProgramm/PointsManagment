class_name UI extends CanvasLayer

func _ready() -> void:
	Global.ui = self
	$Control2/HBC/MC/MenuButton.pressed.connect(toggle_menu)
	

var tween:Tween

func draw_money() -> void:
	if tween and tween.is_running(): tween.kill()
	
	$Control/Money.text = str(Global.money)
	$Control/Money.position.y = -8
	
	tween = create_tween()
	tween.tween_property($Control/Money, "position:y", 4, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

var menu_tween:Tween
var is_menu_open:bool = false

func toggle_menu() -> void:
	if menu_tween and menu_tween.is_running(): menu_tween.kill()
	is_menu_open = !is_menu_open
	
	menu_tween = create_tween()
	menu_tween.tween_property($Control2/HBC/Menu, "size_flags_stretch_ratio", 0.5 if is_menu_open else 0.0, 0.3).set_trans(Tween.TRANS_QUAD)
