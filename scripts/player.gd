extends Area2D

signal death
signal hit

@export var speed = 400
@export var max_lives: int = 3
var default_speed: int
var current_lives: int
var screen_size
var is_dead = false
var is_invincible = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	default_speed = speed
	add_to_group("player")

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
	hit.emit()
	
	if current_lives <= 0:
		die()
		return
	
	$HitAudio.play()
	activate_invincibility()

func start(pos):
	position = pos
	show()
	is_dead = false
	current_lives = max_lives
	$AnimatedSprite2D.play("idle")

func die():
	is_dead = true
	$DeathAudio.play()
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.animation_finished.connect(hide, CONNECT_ONE_SHOT)
	death.emit()

func increase_speed():
	speed += 400
	$Timers/SpeedTimer.start()

func activate_invincibility():
	is_invincible = true
	$AnimatedSprite2D.modulate.a = 0.3
	$Timers/InvincibilityTimer.start()

func _on_speed_timer_timeout() -> void:
	speed = default_speed

func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
	$AnimatedSprite2D.modulate.a = 1.0
