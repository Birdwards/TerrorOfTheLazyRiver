extends PopupPanel

signal start_game

func _ready():
	if AudioServer.is_bus_mute(1):
		$VBoxContainer/HBoxContainer/Sliders/MusicSlider/Slider.value = 0
	else:
		$VBoxContainer/HBoxContainer/Sliders/MusicSlider/Slider.value = pow(0.5, AudioServer.get_bus_volume_db(1)/-6)
	if AudioServer.is_bus_mute(2):
		$VBoxContainer/HBoxContainer/Sliders/SFXSlider/Slider.value = 0
	else:
		$VBoxContainer/HBoxContainer/Sliders/SFXSlider/Slider.value = pow(0.5, AudioServer.get_bus_volume_db(2)/-6)
	$VBoxContainer/HBoxContainer/Buttons/PlayButton.connect("pressed", self, "play_game")
	$VBoxContainer/HBoxContainer/Buttons/QuitButton.connect("pressed", self, "quit_game")
	$VBoxContainer/HBoxContainer/Sliders/MusicSlider/Slider.connect("value_changed", self, "set_music_volume")
	$VBoxContainer/HBoxContainer/Sliders/SFXSlider/Slider.connect("value_changed", self, "set_sfx_volume")
	$VBoxContainer/HBoxContainer/Difficulty/Easy/CheckBox.connect("button_down", Difficulty, "set_difficulty", [0])
	$VBoxContainer/HBoxContainer/Difficulty/Normal/CheckBox.connect("button_down", Difficulty, "set_difficulty", [1])
	$VBoxContainer/HBoxContainer/Difficulty/Hard/CheckBox.connect("button_down", Difficulty, "set_difficulty", [2])
	if Difficulty.level == 0:
		$VBoxContainer/HBoxContainer/Difficulty/Easy/CheckBox.pressed = true
	elif Difficulty.level == 1:
		$VBoxContainer/HBoxContainer/Difficulty/Normal/CheckBox.pressed = true
	elif Difficulty.level == 2:
		$VBoxContainer/HBoxContainer/Difficulty/Hard/CheckBox.pressed = true
	
func play_game():
	#get_tree().change_scene("res://River.tscn")
	emit_signal("start_game")
	hide()
	
func quit_game():
	get_tree().quit()

func set_music_volume(v):
	if v == 0:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		AudioServer.set_bus_volume_db(1, -6*log(v)/log(0.5))

func set_sfx_volume(v):
	if v == 0:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		AudioServer.set_bus_volume_db(2, -6*log(v)/log(0.5))
