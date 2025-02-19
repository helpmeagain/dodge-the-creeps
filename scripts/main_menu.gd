extends Control

@onready var start_button = $VBoxContainer/Start
@onready var options_button = $VBoxContainer/About
@onready var quit_button = $VBoxContainer/Exit

func _ready():
	$AnimatedSprite2D.play()
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn") 

func _on_options_pressed():
	print("Abrir opções...")

func _on_quit_pressed():
	get_tree().quit()
