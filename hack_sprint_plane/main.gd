extends Node2D

@export var mob_scene: PackedScene
@export var barn_scene: PackedScene
@export var silo_scene: PackedScene
@export var tree_scene: PackedScene
@export var monument_scene: PackedScene
var score
var barn_present = false
var silo_present = false
var monument_present = false

func _ready():
	var hud = get_node("HUD")
	if not hud.is_connected("start_game", Callable(self, "_on_start_game")):
		hud.connect("start_game", Callable(self, "_on_start_game"))
	var player = get_node("Player")
	if not player.is_connected("hit", Callable(self, "game_over")):
		player.connect("hit", Callable(self, "game_over"))
	new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BarnTimer.stop()
	$SiloTimer.stop()
	$TreeTimer.stop()
	$MonumentTimer.stop()
	$HUD.show_game_over()

func new_game():
	score = 0
	barn_present = false
	silo_present = false
	monument_present = false  # Reset the monument_present flag
	
	var player = $Player
	if player:
		player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("barns", "queue_free")
	get_tree().call_group("silos", "queue_free")
	get_tree().call_group("trees", "queue_free")
	get_tree().call_group("monuments", "queue_free")

	$MobTimer.wait_time = 2.0
	$BarnTimer.wait_time = 4.0
	$SiloTimer.wait_time = 3.0
	$TreeTimer.wait_time = 1.0
	$MonumentTimer.wait_time = 15.0

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$BarnTimer.start()
	$SiloTimer.start()
	$TreeTimer.start()
	$MonumentTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var screen_size = get_viewport().get_visible_rect().size
	var min_y = 0
	var max_y = 400
	mob.position = Vector2(screen_size.x + 50, randf_range(min_y, max_y))
	mob.rotation = PI
	var velocity = Vector2(-randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity
	mob.z_index = 2  # Ensure mob are behind other objects
	add_child(mob)

func _on_barn_timer_timeout():
	if not barn_present:
		var barn = barn_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var fixed_y = 450
		barn.position = Vector2(screen_size.x + 50, fixed_y)
		barn.rotation = PI
		var velocity = Vector2(-250.0, 0.0)
		barn.linear_velocity = velocity
		barn.connect("barn_exited", Callable(self, "_on_barn_exited"))
		barn.z_index = 1  # Ensure trees are behind other objects
		add_child(barn)
		barn_present = true

func _on_silo_timer_timeout():
	if not silo_present:
		var silo = silo_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var fixed_y = 450
		silo.position = Vector2(screen_size.x + 50, fixed_y)
		silo.rotation = PI
		var velocity = Vector2(-250.0, 0.0)
		silo.linear_velocity = velocity
		silo.connect("silo_exited", Callable(self, "_on_silo_exited"))
		silo.z_index = 0  # Ensure silo are behind other objects
		add_child(silo)
		silo_present = true

func _on_tree_timer_timeout():
	var screen_size = get_viewport().get_visible_rect().size
	var min_y = 460
	var max_y = 460

	for i in range(2):  # to spawn 2 trees
		var tree = tree_scene.instantiate()
		tree.position = Vector2(screen_size.x + 50, randf_range(min_y, max_y))
		tree.rotation = PI
		var velocity = Vector2(-250.0, 0.0)
		tree.linear_velocity = velocity
		tree.connect("tree_left_screen", Callable(self, "_on_tree_left_screen"))
		tree.z_index = -1  # Ensure trees are behind other objects
		add_child(tree)

func _on_monument_timer_timeout():
	print("Monument timer timeout")  # Debugging
	if not monument_present:
		var monument = monument_scene.instantiate()
		var screen_size = get_viewport().get_visible_rect().size
		var fixed_y = 125
		monument.position = Vector2(screen_size.x + 50, fixed_y)
		monument.rotation = PI
		var velocity = Vector2(-250.0, 0.0)
		monument.linear_velocity = velocity
		monument.connect("monument_exited", Callable(self, "_on_monument_exited"))
		monument.z_index = 3  # Ensure silo are behind other objects
		add_child(monument)
		monument_present = true
		print("Monument added to scene")  # Debugging

func _on_barn_exited():
	barn_present = false

func _on_silo_exited():
	silo_present = false

func _on_tree_left_screen():
	pass

func _on_monument_exited():
	print("Monument exited")  # Debugging
	monument_present = false  # Reset the monument_present flag

func _on_start_game():
	print("Start game signal received")  # Debugging
	new_game()
