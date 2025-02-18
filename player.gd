extends Area2D

signal hit

@export var speed = 400
var screen_size
var is_dead = false  # Adicionando uma variável para controlar o estado de morte

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
		$AnimatedSprite2D.animation = "walk"  # Continuar a animação de "walk" enquanto se move
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"  # Fica na animação "idle" quando não se mover

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	
	hide()
	hit.emit()

func start(pos):
	position = pos
	show()
	is_dead = false  # Reseta o estado de morte quando o personagem começa
	$AnimatedSprite2D.play("idle")  # Começa a animação idle

func die():
	is_dead = true  # Define o personagem como morto
	$AnimatedSprite2D.play("death")  # Toca a animação de morte
