extends Node

var level = 1 #0, 1, and 2
var lerp_pct = null
var dart_speed = null
var min_shoot_time = null
var max_shoot_time = null
var wait_shoot_time = null
var num_riders = null

func _ready():
	set_difficulty(1)

func set_difficulty(lvl):
	level = lvl
	if level == 0:
		lerp_pct = 0.02
		dart_speed = 30
		min_shoot_time = 2.5
		max_shoot_time = 5
		wait_shoot_time = 0.5
		num_riders = 15
	elif level == 1:
		lerp_pct = 0.035
		dart_speed = 40
		min_shoot_time = 2
		max_shoot_time = 4
		wait_shoot_time = 1
		num_riders = 20
	elif level == 2:
		lerp_pct = 0.05
		dart_speed = 50
		min_shoot_time = 1.5
		max_shoot_time = 3
		wait_shoot_time = 1.5
		num_riders = 25

func to_text():
	if level == 0:
		return "Easy"
	elif level == 1:
		return "Normal"
	elif level == 2:
		return "Hard"
	return ""
