extends RigidBody2D

signal barn_exited

func _ready():
	var notifier = get_node("VisibleOnScreenNotifier2D")
	if not notifier.is_connected("screen_exited", Callable(self, "_on_visible_on_screen_notifier_2d_screen_exited")):
		notifier.connect("screen_exited", Callable(self, "_on_visible_on_screen_notifier_2d_screen_exited"))

func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("barn_exited")
	queue_free()
