extends Container

@onready var answer: TextEdit = $Node/TextEdit
@onready var response: Label = $Node/Label2

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed('next_stage'):
			if answer.text == 'چاله':
				response.text = 'شما درست حدس زدید. این هم از چاله!!!'
				response.add_theme_color_override("font_color", Color(0, 1, 1))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				Global.success.emit('guess')
			else:
				response.text = 'پاسخ شما اشتباه بود!!!'
				response.add_theme_color_override("font_color", Color(1, 0, 0))
				var timer = Timer.new()
				timer.one_shot = true
				timer.wait_time = 1
				add_child(timer)
				timer.start()
				await timer.timeout
				Global.fail.emit('guess')
				
