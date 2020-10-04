extends PopupPanel

func _ready():
	$VBoxContainer/ResumeButton.connect("pressed", self, "resume_game")
	$VBoxContainer/MenuButton.connect("pressed", self, "go_to_menu")
	
func resume_game():
	get_tree().paused = false
	hide()
	
func go_to_menu():
	get_tree().paused = false
	get_tree().change_scene("res://River.tscn")
