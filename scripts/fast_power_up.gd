extends Area2D

func _ready() -> void:
	add_to_group("game_object")
	$CollisionShape2D.disabled = false

func _on_area_entered(body: Area2D) -> void:
	if body.is_in_group("player"): 
		body.increase_speed()
		queue_free()
		
