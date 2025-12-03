class_name Enemy extends CharacterBody2D

signal DirectionChanged( new_direciton: Vector2 )
signal enemy_stunned( hurt_box: HurtBox )
signal enemy_slain( hurt_box: HurtBox )
signal update_enemy_count( enemy_type: String )
var _player_detected: bool = false
var is_slain: bool = false

@export var detection_zone: Area2D
@export var attack_zone: Area2D
@export var hurt_box: HurtBox
@export var is_slain_data: PresistentDataHandler

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

func SetDirection( _new_direction: Vector2 ) -> bool:
	return false
	
func UpdateAnimation( state: String ) -> void:
	pass
	
func AnimationDirection() -> String:
	return ""
