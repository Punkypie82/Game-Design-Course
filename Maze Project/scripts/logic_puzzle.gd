extends Container

var stage = 0
@onready var logic_label: Label = $Label
@onready var answer: TextEdit = $Node/TextEdit

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed('next_stage'):
			if stage == 0:
				logic_label.text = 'پنج کلاه مشابه\nکه سه تای آنها سفید و دوتای آنها سیاه هستند\nبر روی میزی در برابر زندانیان قرار داشت.\nآدم خواران چشمان زندانیان را باز کردند.\nهر زندانی تنها کلاه افراد روبه روی خود را دید\nو نمی توانست کلاه خودش را ببیند. \n'
			elif stage == 1:
				logic_label.text = 'آدم خواران گفتند که\nاگر کسی رنگ کلاه خودش را به درستی اعلام کند،\nهر سه نفر نجات پیدا کرده و خورده نخواهند شد!\n'
			elif stage == 2:
				logic_label.text = 'آن ها از نفر آخر شروع به پرسیدن کردند.\nنفر آخر گفت: نمی دانم..........\nو به سمت دیگ آب جوش حرکت کرد.\n'
			elif stage == 3:
				logic_label.text = 'نفر دوم هم گفت نمی دانم..........\nو با غم به سمت دیگ راه افتاد. \n'
			elif stage == 4:
				logic_label.text = 'در این لحظه نفر سوم ناگهان فریاد زد:\nصبر کنید. من رنگ کلاه خودم را می دانم!!!!!!!\n\n\nکلاه او چه رنگی است؟؟؟؟؟؟؟؟؟؟؟'
				answer.visible = true
			elif stage == 5:
				if answer.text == 'سفید':
					logic_label.text = 'پاسخ درست. ،\nاکنون دگمه Enter را فشار بده.'
					logic_label.add_theme_color_override("font_color", Color(0, 1, 1))
					answer.visible = false
				else:
					logic_label.text = 'پاسخ اشتباه بود.'
					logic_label.add_theme_color_override("font_color", Color(1, 0, 0))
					answer.visible = false
					
					var timer = Timer.new()
					timer.one_shot = true
					timer.wait_time = 1
					add_child(timer)
					timer.start()
					await timer.timeout
					
					Global.fail.emit('logic')
			elif stage == 6:
				Global.success.emit('logic')
			stage += 1
