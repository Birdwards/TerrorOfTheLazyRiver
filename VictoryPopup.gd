extends PopupPanel

func _ready():
	$VBoxContainer/MenuButton.connect("pressed", self, "replay_game")
	
func replay_game():
	get_tree().paused = false
	get_tree().change_scene("res://River.tscn")
