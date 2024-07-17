extends Control

@onready var clock:Label = $TextureRect/Clock
var class_number:int = 3
var date_slippage:int = 0

@export var timetables:Array[Timetable]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_timetable_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	clock.set("text", get_time_string())
	$TextureRect/Period.set("text", get_stat())
	if get_time() == 0:
		update_timetable_display()

func get_time():
	return Time.get_datetime_dict_from_system().hour * 60 + Time.get_datetime_dict_from_system().minute
func get_time_string():
	if str(Time.get_datetime_dict_from_system().minute).length() <= 1:
		return str(Time.get_datetime_dict_from_system().hour) + ":0" + str(Time.get_datetime_dict_from_system().minute)
	else:
		return str(Time.get_datetime_dict_from_system().hour) + ":" + str(Time.get_datetime_dict_from_system().minute)
func convert_time_for_compareson(hour:int, minute:int):
	return hour * 60 + minute
func get_period():
	if get_time() <= convert_time_for_compareson(9, 0):
		return -1
	if get_time() >= convert_time_for_compareson(9, 0) and get_time() <= convert_time_for_compareson(10, 30):
		return 1
	elif get_time() >= convert_time_for_compareson(10, 30) and get_time() <= convert_time_for_compareson(12, 10):
		return 2
	elif get_time() >= convert_time_for_compareson(13, 0) and get_time() <= convert_time_for_compareson(14, 30):
		return 3
	elif get_time() >= convert_time_for_compareson(14, 30) and get_time() <= convert_time_for_compareson(16, 10):
		return 4
	elif get_time() >= convert_time_for_compareson(16, 10):
		return -2
func get_ordinal(num:int):
	if num == 1:
		return str(num) + "st"
	elif num == 2:
		return str(num) + "nd"
	elif num == 3:
		return str(num) + "rd"
	else:
		return str(num) + "th"
func get_stat():
	if Time.get_datetime_dict_from_system().weekday == 0 or Time.get_datetime_dict_from_system().weekday == 6:
		return ""
	else:
		if get_period() >= 0:
			return get_ordinal(get_period()) + " Period"
		elif get_time() <= convert_time_for_compareson(9, 0):
			return "Before School"
		elif get_time() >= convert_time_for_compareson(16, 10):
			return "After School"

func update_timetable_display():
	$"Timetable/You have nothing classes today".set("visible", false)
	if date_slippage == 0:
		$TextureRect/Label.set("text", "Today's\nclasses")
	else:
		$TextureRect/Label.set("text", get_weekday_string(get_slippaged_date()) + "'s\nclasses")
	
	for _i in range($Timetable/ScrollContainer/Classes.get_child_count()):
		$Timetable/ScrollContainer/Classes.get_child(_i).queue_free()
	
	for _i in range(get_timetable_from_weekday(get_slippaged_date()).size()):
		var class_indicator_temp:Control = preload("res://Functions/Classes/class_display.tscn").instantiate()
		
		class_indicator_temp.get_child(0).set("text", get_ordinal(_i + 1) + " " + get_timetable_from_weekday(get_slippaged_date())[_i].className)
		if not get_timetable_from_weekday(get_slippaged_date())[_i].class_teacher == "":
			class_indicator_temp.get_child(1).set("text", get_timetable_from_weekday(get_slippaged_date())[_i].class_teacher + ", " + get_formatted_time(get_begin_time(_i)))
		else:
			class_indicator_temp.get_child(1).set("text", get_formatted_time(get_begin_time(_i)))
		
		$Timetable/ScrollContainer/Classes.add_child(class_indicator_temp)
	if get_timetable_from_weekday(get_slippaged_date()).is_empty():
		$"Timetable/You have nothing classes today".set("visible", true)
	else:
		$"Timetable/You have nothing classes today".set("visible", false)
func get_begin_time(period_num:int):
	#Notice: period_numは0を基準に開始される。つまり、我々が一コマ目と呼んでいるのが0になるわけである。
	if period_num < 2:
		return 9 * 60 + period_num * 100
	else:
		return 9 * 60 + period_num * 100 + 50
func get_formatted_time(time:int):
	if str(time % 60).length() < 2:
		return str(floor(time / 60)) + ":0" + str(time % 60) + "~"
	else:
		return str(floor(time / 60)) + ":" + str(time % 60) + "~"
func is_holiday():
	if get_slippaged_date() == 0 or get_slippaged_date() == 6:
		return true

func get_timetable_from_weekday(weekday:int):
	if weekday == 1:
		return timetables[class_number].mon_timetable
	elif weekday == 2:
		return timetables[class_number].tue_timetable
	elif weekday == 3:
		return timetables[class_number].wed_timetable
	elif weekday == 4:
		return timetables[class_number].thu_timetable
	elif weekday == 5:
		return timetables[class_number].fri_timetable
	else:
		return []

func _on_last_day_button_down():
	date_slippage -= 1
	update_timetable_display()
func _on_next_day_button_down():
	date_slippage += 1
	update_timetable_display()

func get_slippaged_date():
	return (Time.get_datetime_dict_from_system().weekday + date_slippage) % 7
func get_weekday_string(weekday:int):
	if weekday == 0:
		return "Sun"
	elif weekday == 1:
		return "Mon"
	elif weekday == 2:
		return "Tue"
	elif weekday == 3:
		return "Wed"
	elif weekday == 4:
		return "Thu"
	elif weekday == 5:
		return "Fri"
	elif weekday == 6:
		return "Sat"
