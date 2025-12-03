extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_out( _play_audio: bool = true ) -> bool:
	if _play_audio:
		animation_player.play('fade_out_audio')
	else:
		animation_player.play('fade_out')
	await animation_player.animation_finished
	return true

func fade_in() -> bool:
	animation_player.play('fade_in')
	await animation_player.animation_finished
	return true
