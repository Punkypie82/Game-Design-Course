class_name Boomerang extends Node2D

enum State { INACTIVE, THROW, RETURN }

var player: Player
var direction: Vector2
var speed: float = 0.0
var state

@export var acceleration: float = 1000.0
@export var max_speed: float = 800.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boomerang_audio: AudioStreamPlayer = $Audio/BoomerangAudio

func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player
	
func _physics_process( delta: float ) -> void:
	if state == State.THROW:
		speed -= acceleration * delta
		position += direction * speed * delta
		if speed <= 0:
			state = State.RETURN
		pass
	elif state == State.RETURN:
		direction = global_position.direction_to( player.global_position - Vector2(0, 100) )
		speed += acceleration * delta
		position += direction * speed * delta
		if global_position.distance_to( player.global_position - Vector2(0, 100) ) <= 10:
			queue_free()
		pass
	
	var speed_ratio = speed / max_speed
	boomerang_audio.pitch_scale = speed_ratio * 0.75 + 0.75
	animation_player.speed_scale = 1 + ( speed_ratio * 0.25 )
	pass
	
func throw( throw_direction: Vector2 ) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	animation_player.play( 'boomerang' )
	visible = true
	pass
