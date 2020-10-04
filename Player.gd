extends KinematicBody2D

var play_active = false

var swim_vel = Vector2.ZERO
var current_dir = Vector2.ZERO
var current_vel = 40
var swim_accel = 100
var swim_decel = 100
var max_swim_vel = 30
onready var screen_center = get_viewport().size * 0.5

signal game_over

func _ready():
	$DieTimer.connect("timeout", self, "finish_die")

func _physics_process(delta):
	if not $CollisionShape2D.disabled:
		var vel = Vector2.ZERO
		vel = current_dir.normalized() * current_vel
		
		var swim_dir = Vector2.ZERO
		if play_active:
			if Input.is_action_pressed("ui_right"):
				swim_dir.x += 1
			if Input.is_action_pressed("ui_left"):
				swim_dir.x -= 1
			if Input.is_action_pressed("ui_down"):
				swim_dir.y += 1
			if Input.is_action_pressed("ui_up"):
				swim_dir.y -= 1
			swim_dir = swim_dir.normalized()
		
		if swim_dir == Vector2.ZERO:
			swim_vel = swim_vel.clamped(max(swim_vel.length() - delta * swim_decel, 0))
		else:
			swim_vel += swim_dir * delta * swim_accel
			swim_vel = swim_vel.clamped(max_swim_vel)
		
		vel += swim_vel
		
		move_and_slide(vel)
		current_dir = Vector2.ZERO
		
		if play_active:
			$Sprite.rotation = (get_viewport().get_mouse_position() - screen_center).angle()
				
			if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "slash":
				var bodies = $Needle.get_overlapping_bodies()
				for b in bodies:
					if b.filename == "res://Rider.tscn":
						b.pop_tube()
					elif b.filename == "res://Dart.tscn":
						b.queue_free()
			elif Input.is_action_just_pressed("slash"):
				$Needle.rotation = $Sprite.rotation
				$AnimationPlayer.play("slash")
				$SlashSound.play()

func current_push(push_dir):
	current_dir += push_dir.normalized()

func die():
	$Splash.emitting = true
	$Sprite.rotation = 0
	$Sprite.frame += 1
	$CollisionShape2D.disabled = true
	$DeflateSound.play()
	$DieTimer.start()
	
func finish_die():
	visible = false
	emit_signal("game_over")

func activate():
	play_active = true
