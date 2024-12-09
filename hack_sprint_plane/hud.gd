extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

func _ready() -> void:
	var start_button = get_node("StartButton")
	var message_timer = get_node("MessageTimer")
	if not start_button.is_connected("pressed", Callable(self, "_on_start_button_pressed")):
		start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	if not message_timer.is_connected("timeout", Callable(self, "_on_message_timer_timeout")):
		message_timer.connect("timeout", Callable(self, "_on_message_timer_timeout"))
	start_button.hide()
	
func show_message(text):
	var message = get_node("Message")
	var message_timer = get_node("MessageTimer")
	message.text = text
	message.show()
	message_timer.start()
	
func show_game_over():
	show_message("Game Over")
	await get_node("MessageTimer").timeout
	var message = get_node("Message")
	message.text = "Dodge the Obstacles!"
	message.show()
	await get_tree().create_timer(1.0).timeout
	get_node("StartButton").show()

func update_score(score):
	get_node("ScoreLabel").text = str(score)

func _on_start_button_pressed():
	print("Start button pressed")  # Debugging
	get_node("StartButton").hide()
	emit_signal("start_game")

func _on_message_timer_timeout():
	get_node("Message").hide()
