class_name UI extends CanvasLayer

func _ready() -> void:
	Global.ui = self

var tween:Tween

func draw_money() -> void:
	if tween and tween.is_running(): tween.kill()
	
	$Control/Money.text = str(Global.money)
	$Control/Money.position.y = -8
	
	tween = create_tween()
	tween.tween_property($Control/Money, "position:y", 4, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
