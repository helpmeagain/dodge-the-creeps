extends Area2D

signal hit

@export var speed = 400
@export var max_lives: int = 3
var current_lives: int
var screen_size
var is_dead = false
var speed_timer: Timer
var invincibility_timer: Timer 
var default_speed: int
var is_invincible = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	default_speed = speed
	add_to_group("player")
	
	speed_timer = Timer.new()
	speed_timer.wait_time = 3
	speed_timer.one_shot = true
	speed_timer.connect("timeout", Callable(self, "_reset_speed"))
	add_child(speed_timer)

	invincibility_timer = Timer.new()
	invincibility_timer.wait_time = 3 
	invincibility_timer.one_shot = true
	invincibility_timer.connect("timeout", Callable(self, "_reset_invincibility"))
	add_child(invincibility_timer)

func _process(delta: float) -> void:
	if is_dead:
		return
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("mover_direita"):
		velocity.x += 1
	if Input.is_action_pressed("mover_esquerda"):
		velocity.x -= 1
	if Input.is_action_pressed("mover_baixo"):
		velocity.y += 1
	if Input.is_action_pressed("mover_cima"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body: Node2D) -> void:
	if is_invincible or is_dead:
		return
	
	current_lives -= 1
	get_parent().update_lives_ui()
	
	if current_lives <= 0:
		die()
		hit.emit()
		return
	activate_invincibility()

func start(pos):
	position = pos
	show()
	is_dead = false
	current_lives = max_lives
	get_parent().update_lives_ui()
	$AnimatedSprite2D.play("idle")

func die():
	is_dead = true
	$AnimatedSprite2D.play("death")
	hide()

func increase_speed():
	speed += 400
	speed_timer.start()

func _reset_speed():
	speed = default_speed

func activate_invincibility():
	is_invincible = true
	$AnimatedSprite2D.modulate.a = 0.3
	invincibility_timer.start()

func _reset_invincibility():
	is_invincible = false
	$AnimatedSprite2D.modulate.a = 1.0
