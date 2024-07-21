extends Control

@export var lesson_datas:Array[Lesson]

func _ready():
	visible = true
	for _i in range(lesson_datas.size()):
		var _temp = Button.new()
		_temp.text = lesson_datas[_i].lesson_name + "\n[" + str(Lesson.Subjects.keys()[lesson_datas[_i].subject]) + "]" 
		$VBoxContainer.add_child(_temp)
		_temp.button_down.connect(goto_lesson.bind(_i))

func goto_lesson(num:int):
	$"../Lesson".start_lesson(lesson_datas[num].questions)
	self.visible = false
	$"../Lesson".visible = true
