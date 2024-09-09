extends Control

@export var lesson_datas:Array[Lesson]
@onready var button_container = $MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer

func _ready():
	visible = true
	list_up("All")

func list_up(categoly:String):
	var categolies = Lesson.Subjects.keys()
	categolies.append("All")
	
	for _i in range(button_container.get_child_count()):
		button_container.get_child(_i).queue_free()
	if not categoly in categolies:
		push_error("%s is a invalid categoly" % categoly)
		return
	
	var lessons:Array[Lesson] = lesson_datas
	for _i in range(Lesson.Subjects.keys().size()):
		var config = ConfigFile.new()
		config.load("user://config.cfg")
		
		var _root = "user://Lessons/%s/%s" % ["%sGrade" % [get_ordinal(config.get_value("global", "grade"))], Lesson.Subjects.keys()[_i]]
		
		var _file_passes_ = DirAccess.get_files_at(_root)
		for _ii in range(_file_passes_.size()):
			var loaded_file = load("%s/%s" % [_root, _file_passes_[_ii]])
			print("%s/%s" % [_root, _file_passes_[_ii]])
			if loaded_file is Lesson:
				lessons.append(loaded_file)
	
	for _i in range(lessons.size()):
		if categoly == str(Lesson.Subjects.keys()[lessons[_i].subject]) or categoly == "All":
			var _temp = Button.new()
			_temp.custom_minimum_size.x = get_viewport().size.x * 0.863
			_temp.text = lessons[_i].lesson_name + "\n[" + str(Lesson.Subjects.keys()[lessons[_i].subject]) + "]" 
			button_container.add_child(_temp)
			_temp.button_down.connect(goto_lesson.bind(_i))

func goto_lesson(num:int):
	print($"../".get_children())
	$"../Lesson".start_lesson(lesson_datas[num].questions)
	self.visible = false
	$"../Lesson".visible = true


func _on_option_button_item_selected(index):
	list_up($MarginContainer/ScrollContainer/VBoxContainer/OptionButton.get_item_text(index))

func get_ordinal(num:int):
	if num == 1:
		return str(num) + "st"
	elif num == 2:
		return str(num) + "nd"
	elif num == 3:
		return str(num) + "rd"
	else:
		return str(num) + "th"
