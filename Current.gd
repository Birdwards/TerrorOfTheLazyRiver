extends Area2D

export var dir = Vector2()

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for b in bodies:
		if b.name == "Player" or b.filename == "res://Rider.tscn":
			b.current_push(dir)
