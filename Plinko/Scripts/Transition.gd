class_name Transition extends Panel

signal OnTransitionFinished()
signal OnTransitionMiddle()

var transitionIn: bool = true
var transitionValue: float = 0.0

func _process(delta: float) -> void:
	transitionValue = move_toward(transitionValue, 1.0 if transitionIn else 0.0, 0.025)
	material.set('shader_parameter/progress', transitionValue)
	mouse_filter = Control.MOUSE_FILTER_STOP if transitionIn else Control.MOUSE_FILTER_IGNORE

	if is_equal_approx(transitionValue, 1.0) and transitionIn:
		await get_tree().create_timer(0.25).timeout
		transitionIn = false
		OnTransitionMiddle.emit()





