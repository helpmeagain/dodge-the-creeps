extends StaticBody2D

func _ready() -> void:
	add_to_group("dragons")
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	pass
