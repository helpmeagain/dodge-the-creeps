extends Area2D

signal power_up_collected

func _ready() -> void:
	$CollisionShape2D.disabled = false

func _on_area_entered(body: Area2D) -> void:
	if body.is_in_group("player"): 
		body.increase_speed()
		queue_free()
		emit_signal("power_up_collected")
