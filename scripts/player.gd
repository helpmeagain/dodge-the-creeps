extends Area2D

signal hit

@export var speed = 400
@export var max_lives: int = 3
var current_lives: int
var screen_size
var is_dead = false

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if is_dead:  # Verifica se o personagem morreu, e não processa mais movimento
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
	if is_dead:
		return
	
	current_lives -= 1
	get_parent().update_lives_ui()
	
	if current_lives <= 0:
		die()
		hit.emit()
	else:
		position = get_parent().get_node("StartPosition").position

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
