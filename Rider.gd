extends KinematicBody2D

var Dart = preload("res://Dart.tscn")

var play_active = false

var current_dir = Vector2.ZERO
const current_vel = 25
var current_mod = 0
const max_current_mod = deg2rad(10)
const del_current_mod = deg2rad(0.1)

const sight_radius = 98

var to_player = null
var player = null
var is_popped = false

signal popped

func _ready():
	randomize()
	$DieTimer.connect("timeout", self, "finish_die")
	$ShootTimer.connect("timeout", self, "maybe_shoot")

func _physics_process(delta):
	to_player = player.position - position
	
	if not is_popped:
		if play_active:
			$Sprite.rotation = lerp_angle($Sprite.rotation, to_player.angle(), Difficulty.lerp_pct)
		
		var d_current_mod = randi()%3-1
		current_mod += d_current_mod * del_current_mod
		current_mod = clamp(current_mod, -max_current_mod, max_current_mod)
		
		current_dir = current_dir.rotated(current_mod)
		
		move_and_slide(current_dir.normalized() * current_vel)
		current_dir = Vector2.ZERO

func current_push(push_dir):
	current_dir += push_dir.normalized()

func pop_tube():
	emit_signal("popped", self)
	$Splash.emitting = true
	$Sprite.frame += 1
	$CollisionShape2D.disabled = true
	Music.get_node("DeflateRider").play()
	$DieTimer.start()
	is_popped = true
	$Sprite.rotation = 0
	
func finish_die():
	self.queue_free()

func set_frame(n):
	$Sprite.frame = n

func maybe_shoot():
	if to_player != null and abs(to_player.x) < 160 and abs(to_player.y) < 90 and not is_popped:
		$ShootTimer.start(rand_range(Difficulty.min_shoot_time, Difficulty.max_shoot_time))
		var gun_vector = Vector2(cos($Sprite.rotation), sin($Sprite.rotation))
		var new_dart = Dart.instance()
		new_dart.position = gun_vector * 8
		new_dart.vel = gun_vector * Difficulty.dart_speed
		new_dart.rotation = $Sprite.rotation 
		add_child(new_dart)
		$ShootSound.play()

func activate():
	play_active = true
	$ShootTimer.start(rand_range(Difficulty.min_shoot_time, Difficulty.max_shoot_time)+Difficulty.wait_shoot_time)
