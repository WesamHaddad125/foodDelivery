extends ProgressBar
class_name CustomHealthBar
 
@export var progress_bar: ProgressBar
@export var always_visible : bool
@onready var reset_vis: Timer = $ResetVis

var change_value_tween: Tween
var opacity_tween: Tween

func _setup_health_bar(current_val: float, max_val: float):
	if !always_visible:
		modulate.a = 0.0
	value = current_val
	max_value = max_val
	progress_bar.value = current_val
	progress_bar.max_value = max_val
	
func change_value(new_value: float):
	_change_opacity(1.0)
	
	value = new_value
	
	if change_value_tween:
		change_value_tween.kill()
	change_value_tween = create_tween()
	if !always_visible:
		change_value_tween.finished.connect(reset_vis.start)
	change_value_tween.tween_property(progress_bar, "value", new_value, 0.35).set_trans(Tween.TRANS_SINE)
	
func _change_opacity(new_amount: float):
	if opacity_tween:
		opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", new_amount, 0.12).set_trans(Tween.TRANS_SINE)


func _on_reset_vis_timeout() -> void:
	_change_opacity(0.0)
