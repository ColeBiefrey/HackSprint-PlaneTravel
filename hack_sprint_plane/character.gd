extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))
	print("Character ready and signal connected")

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
	# Move the character using move_and_slide
	move_and_slide(velocity)

	# Clamp the y position to not go below 500
	position.y = min(position.y, 500)
	
	# Clamp the position within the screen size
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body):
	print("Collision detected with: ", body)
	if body.is_in_group("obstacles"):
		print("Collision with obstacle detected")
		restart_game()

func restart_game():
	print("Restarting game")
	get_tree().reload_current_scene()
