extends Node2D

var Rider = preload("res://Rider.tscn")

const screen_size = Vector2(320,180)
const popup_size = Vector2(160,120)
const rider_spawn_offset = Vector2(8,8)
var riders = []
var time_elapsed = 0
var game_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$Splash.emitting = true
	$GUI/MainMenu.connect("start_game", self, "start_game")
	$GUI/MainMenu.popup_centered(screen_size)
	$YSort/Player.connect("game_over", self, "game_over")
		
func _process(delta):
	if game_started:
		time_elapsed += delta
	var minutes = floor(time_elapsed/60)
	var seconds = int(time_elapsed*100)%6000/100.0
	$GUI/TimeElapsed/Label.text = str(minutes).pad_zeros(2) + "\'" + str(seconds).pad_zeros(2).pad_decimals(2) + "\""
	if game_started and Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$GUI/PausePopup.popup_centered(popup_size)

func subtract_rider(r):
	riders.erase(r)
	$GUI/RidersLeft/Label.text = "Riders left: " + str(riders.size()) + "/" + str(Difficulty.num_riders)
	if riders.size() == 0:
		get_tree().paused = true
		$GUI/TimeElapsed.visible = false
		$GUI/RidersLeft.visible = false
		$GUI/VictoryPopup/VBoxContainer/DifficultyLevel.text = "Difficulty: " + Difficulty.to_text()
		$GUI/VictoryPopup/VBoxContainer/TimeElapsed.text = "Time: " + $GUI/TimeElapsed/Label.text
		$GUI/VictoryPopup.popup_centered(popup_size)

func game_over():
	get_tree().paused = true
	$GUI/TimeElapsed.visible = false
	$GUI/RidersLeft.visible = false
	$GUI/GameOverPopup/VBoxContainer/DifficultyLevel.text = "Difficulty: " + Difficulty.to_text()
	$GUI/GameOverPopup/VBoxContainer/RidersSunk.text = "Riders sunk: " + str(Difficulty.num_riders - riders.size()) + "/" + str(Difficulty.num_riders)
	$GUI/GameOverPopup.popup_centered(popup_size)

func start_game():
	$GUI/TimeElapsed.visible = true
	$GUI/RidersLeft/Label.text = "Riders left: " + str(riders.size()) + "/" + str(Difficulty.num_riders)
	$GUI/RidersLeft.visible = true
	$YSort/Player.activate()
	game_started = true
	var available_tiles = $TileMap.get_used_cells_by_id(0)
	for r in range(Difficulty.num_riders):
		var new_rider = Rider.instance()
		var tile_idx = randi() % available_tiles.size()
		new_rider.position = $TileMap.map_to_world(available_tiles[tile_idx]) + $TileMap.position + rider_spawn_offset
		new_rider.set_frame((r%10+1)*2)
		new_rider.player = $YSort/Player
		riders.append(new_rider)
		$YSort.add_child(new_rider)
		new_rider.connect("popped", self, "subtract_rider")
		new_rider.activate()
		available_tiles.remove(tile_idx)
