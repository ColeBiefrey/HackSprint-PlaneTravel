extends RigidBody2D

signal tree_left_screen

@export var textures: Array[Texture]  # Array of textures to choose from

func _ready():
	var notifier = get_node("VisibleOnScreenNotifier2D")
	if notifier:
		notifier.connect("screen_exited", Callable(self, "_on_visible_on_screen_notifier_2d_screen_exited"))
	else:
		print("VisibleOnScreenNotifier2D node not found")

	# Randomly select a texture from the array and apply it to the Sprite
	if textures.size() > 0:
		var random_texture = textures[randi() % textures.size()]
		$Sprite.texture = random_texture

func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("tree_left_screen")
	queue_free()
