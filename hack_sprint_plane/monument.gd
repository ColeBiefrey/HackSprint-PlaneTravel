extends RigidBody2D

signal monument_exited

func _ready():
	var notifier = get_node("VisibleOnScreenNotifier2D")
	if notifier:
		if not notifier.is_connected("screen_exited", Callable(self, "_on_visible_on_screen_notifier_2d_screen_exited")):
			notifier.connect("screen_exited", Callable(self, "_on_visible_on_screen_notifier_2d_screen_exited"))
	else:
		print("VisibleOnScreenNotifier2D node not found")

	# Set the initial velocity for the monument
	linear_velocity = Vector2(-250.0, 0.0)

func _on_visible_on_screen_notifier_2d_screen_exited():
	print("Monument exited screen")  # Debugging
	emit_signal("monument_exited")
	queue_free()
