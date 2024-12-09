extends Area2D

@export var speed = 200 # Speed at which the obstacle moves (pixels/sec).

func _ready():
	add_to_group("obstacles")
	print("Obstacle ready and added to group")

func _process(delta):
	# Move the obstacle left on the x-axis
	position.x -= speed * delta

	# If the obstacle moves off the screen, queue it for deletion
	if position.x < -get_viewport().get_visible_rect().size.x:
		queue_free()
