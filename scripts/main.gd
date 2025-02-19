extends Node

@export var mob_scene: PackedScene
var score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CanvasLayer/GameOver.show()
	$CanvasLayer/ResetButton.show()
	$CanvasLayer/ExitButton.show()

func new_game():
	score = 0
	$CanvasLayer/Score.text = "Score: 0"
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/Score.text = "Score: " + str(score)

func _on_start_timer_timeout() -> void:
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

func _on_reset_button_pressed() -> void:
	$CanvasLayer/GameOver.hide()
	$CanvasLayer/ResetButton.hide()
	$CanvasLayer/ExitButton.hide()
	new_game()

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") 
	
func update_lives_ui():
	$CanvasLayer/Lifes.text = "Lifes: " + str($Player.current_lives)
