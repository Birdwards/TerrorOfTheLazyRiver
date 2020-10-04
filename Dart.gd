extends KinematicBody2D

var vel = Vector2.ZERO

func _physics_process(delta):
	var collision = move_and_collide(vel*delta)
	if collision != null:
		queue_free()
		if collision.collider.name == "Player":
			collision.collider.die()
