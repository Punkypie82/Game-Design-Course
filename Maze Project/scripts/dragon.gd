extends Container

var stage = 0
@onready var dragon_label: Label = $Label
@onready var game_manager: Node = %GameManager
@onready var answer: TextEdit = $Node/TextEdit

func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed('next_stage'):
			if stage == 0:
				dragon_label.text = 'هر یک از سرهای ما معمایی برات دارد؛\nسه چیستانکه هر یک از دیگری سخت تر است.\nاگر با علم خود بتوانی هر سه را درست پاسخ دهی،\nما این دیوار را در آتش میسوزانیم و راهت را باز می کنیم.\nاما اگر حتی در یکی شکست بخوری، در شعله های ما خواهی سوخت.'
			elif stage == 1:
				dragon_label.text = 'اگر آماده ای تا با ما در نبردی هوشمندانه وارد شوی،\nدکمه Enter را بزن تا اولین چیستان نمایان شود.\nتنها خرد و شجاعت توست که می تواند تو را نجات دهد. \nبه خاطر داشته باش که هرقدم در این مسیر،\nدشوارتر از قدم پیشین است.'
			elif stage == 2:
				dragon_label.text = 'آن چیست که در فرانسه، کره جنوبی، کره شمالی، عربستان،\nعراق و ترکمنستان دوم شده است اما در روسیه اول؟'
				answer.visible = true
			elif stage == 3:
				if answer.text == 'ر':
					answer.visible = false
					dragon_label.text = 'بسیار خوب، پاسخ درست بود. اکنون آماده ی سوال دوم باش.'
					answer.clear()
				else:
					dragon_label.text = 'پاسخ اشتباه بود. اکنون میسوزی.'
					dragon_label.add_theme_color_override("font_color", Color(1, 0, 0))
					answer.visible = false
					
					var timer = Timer.new()
					timer.one_shot = true
					timer.wait_time = 1
					add_child(timer)
					timer.start()
					await timer.timeout
					
					Global.fail.emit('dragon')
			elif stage == 4:
				dragon_label.text = 'وقتی از قطب، دشت کویر و لب ساحل برمیگردم، او می ماند.'
				answer.visible = true
			elif stage == 5:
				if answer.text == 'رد پا':
					answer.visible = false
					dragon_label.text = 'خوب کار کردی، اما سوال آخر دشوارتر خواهد بود'
					answer.clear()
				else:
					dragon_label.text = 'پاسخ اشتباه بود. اکنون میسوزی.'
					dragon_label.add_theme_color_override("font_color", Color(1, 0, 0))
					answer.visible = false
					
					var timer = Timer.new()
					timer.one_shot = true
					timer.wait_time = 1
					add_child(timer)
					timer.start()
					await timer.timeout
					
					Global.fail.emit('dragon')
			elif stage == 6:
				dragon_label.text = 'عمر مرا با ساعت اندازه می گیرند\nو با پایان یافتنم به توخدمت می کنم.\nوقتی لاغر باشم سریعم و وقتی چاق باشم کند.\nباد دشمن من است.'
				answer.visible = true
			elif stage == 7:
				if answer.text == 'شمع':
					dragon_label.text = 'تو توانستی از هر سه چیستان عبور کنی،\nاکنون دگمه Enter را فشار بده و از آزادی خود لذت ببر...'
					dragon_label.add_theme_color_override("font_color", Color(0, 1, 1))
					answer.visible = false
				else:
					dragon_label.text = 'پاسخ اشتباه بود. اکنون میسوزی.'
					dragon_label.add_theme_color_override("font_color", Color(1, 0, 0))
					answer.visible = false
					
					var timer = Timer.new()
					timer.one_shot = true
					timer.wait_time = 1
					add_child(timer)
					timer.start()
					await timer.timeout
					
					Global.fail.emit('dragon')
			elif stage == 8:
				Global.success.emit('dragon')
			stage += 1
