extends Node2D

signal hit

@export var speed = 300
@export var min_x = 0
@export var max_x = 800
@export var min_y = 20
@export var max_y = 550

var screen_size


@onready var oops = $"../Crash" #readys audio for play on collision

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	start(Vector2(screen_size.x / 2, screen_size.y / 2))

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		if velocity.x < 0:
			velocity = velocity.normalized() * speed * 0.5
		else:
			velocity = velocity.normalized() * speed
		get_node("AnimatedSprite2D").play()
	else:
		get_node("AnimatedSprite2D").play("straight")  # Play "straight" animation when no button is pressed
		
	position += velocity * delta
	position.x = clamp(position.x, min_x, max_x)
	position.y = clamp(position.y, min_y, max_y)
	
	if velocity.y > 0:
		get_node("AnimatedSprite2D").animation = "down"
	elif velocity.y < 0:
		get_node("AnimatedSprite2D").animation = "up"
	else:
		get_node("AnimatedSprite2D").animation = "straight"
	
	get_node("AnimatedSprite2D").flip_v = false
	get_node("AnimatedSprite2D").flip_h = false

func _on_body_entered(_body):
	oops.play() #calls for the collision sound
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	print("Player start function called")  # Debugging
	position = pos
	show()
	$CollisionShape2D.disabled = false
