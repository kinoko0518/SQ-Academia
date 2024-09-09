extends Control


var vannila_question:Control

func _ready():
	vannila_question = $MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer/Question.duplicate()
	$MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/Button.button_down.connect(question_added)
	$MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/Button2.button_down.connect(export)
	for _i in range(Lesson.Subjects.keys().size()):
		$MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/Subject.add_item(Lesson.Subjects.keys()[_i])

func question_added():
	vannila_question = vannila_question.duplicate()
	$MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer.add_child(vannila_question)

func export():
	var export_file = Lesson.new()
	export_file.lesson_name = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/LessonName.text
	export_file.subject = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/VBoxContainer/Subject.selected
	for _i in range($MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer.get_child_count()):
		export_file.questions.append($MarginContainer/ScrollContainer/VBoxContainer/VBoxContainer.get_child(_i).compile())
	
	ResourceSaver.save(export_file, "user://Lessons/%s/%s_%s.tres" % [Lesson.Subjects.keys()[export_file.subject], Lesson.Subjects.keys()[export_file.subject], export_file.lesson_name])
	
	var lesson = preload("res://Functions/Study/UI/Lesson.tscn").instantiate()
	add_child(lesson)
	lesson.start_lesson(export_file.questions, true)
	await lesson.lesson_finished
	lesson.queue_free()
