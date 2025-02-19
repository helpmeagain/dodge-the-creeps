extends Node

@export var mob_scene: PackedScene
@export var dragon_scene: PackedScene
@export var power_up_scene: PackedScene
var power_up_timer: Timer
var score

func _ready() -> void:
	new_game()
	power_up_timer = Timer.new()
	add_child(power_up_timer)
	
	power_up_timer.wait_time = 20
	power_up_timer.one_shot = false
	power_up_timer.connect("timeout", Callable(self, "_spawn_power_up"))
	power_up_timer.start()

func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$DragonTimer.stop()
	$CanvasLayer/GameOver.show()
	$CanvasLayer/ResetButton.show()
	$CanvasLayer/ExitButton.show()
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.queue_free()

	for dragon in get_tree().get_nodes_in_group("dragons"):
		dragon.queue_free()

func new_game():
	score = 0
	$CanvasLayer/Score.text = "Score: 0"
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/Score.text = "Score: " + str(score)

func _on_start_timer_timeout() -> void:
	$DragonTimer.start()
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_location = $MobPath/LocalMobGeneration
	mob_location.progress_ratio = randf()
	
	var direction = mob_location.rotation + PI / 2
	
	mob.position = mob_location.position
	
	direction += randf_range(-PI /4, PI /4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_dragon_timer_timeout() -> void:
	var dragon = dragon_scene.instantiate()
	add_child(dragon)
	
	var screen_size = get_viewport().get_visible_rect().size
	var direction = randf() < 0.5
	var start_pos: Vector2
	var end_pos: Vector2
	
	if direction:
		start_pos = Vector2(-100, randf_range(50, screen_size.y - 50))
		end_pos = Vector2(screen_size.x + 100, start_pos.y)
	else:
		start_pos = Vector2(screen_size.x + 100, randf_range(50, screen_size.y - 50))
		end_pos = Vector2(-100, start_pos.y)
	
	dragon.position = start_pos
	if direction: 
		dragon.get_node("AnimatedSprite2D").flip_h = true
	
	var tween = create_tween()
	tween.tween_property(dragon, "position", end_pos, 5.0)
	tween.tween_callback(dragon.queue_free)

func _on_reset_button_pressed() -> void:
	$CanvasLayer/GameOver.hide()
	$CanvasLayer/ResetButton.hide()
	$CanvasLayer/ExitButton.hide()
	new_game()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") 

func update_lives_ui():
	$CanvasLayer/Lifes.text = "Lifes: " + str($Player.current_lives)

func _spawn_power_up():
	var power_up = power_up_scene.instantiate()
	var spawn_position = Vector2(randf_range(100, get_viewport().size.x - 100), randf_range(100, get_viewport().size.y - 100))
	power_up.position = spawn_position
	add_child(power_up)
