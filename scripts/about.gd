extends Control

func _on_git_hub_button_pressed() -> void:
	OS.shell_open("https://github.com/helpmeagain")


func _on_documentation_button_pressed() -> void:
	OS.shell_open("https://github.com/helpmeagain/dodge-the-creeps/blob/main/README.md")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") 
