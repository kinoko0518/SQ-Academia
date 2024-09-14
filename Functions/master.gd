extends Control

@export var features:Array[Feature]
@export var debug_features:Array[Feature]

var swipe_start = null
var minimum_drag = 100
var is_opening:bool = true
var current_feature:Control = null
@onready var active_panel = $SlideMenu

signal left_drugged
signal right_drugged
signal up_drugged
signal down_drugged

func _input(event):
	if Input.is_action_just_pressed("on_clicked"):
		swipe_start = event.get_position()
	if Input.is_action_just_released("on_clicked"):
		_calculate_swipe(event.get_position())

func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			right_drugged.emit()
		else:
			left_drugged.emit()
	if abs(swipe.y) > minimum_drag:
		if swipe.y > 0:
			down_drugged.emit()
		else:
			up_drugged.emit()

func _ready():
	#region Syncing lesson datas with lessons on GitHub
	var sync_requester = HTTPRequest.new()
	add_child(sync_requester)
	sync_requester.request_completed.connect(_on_sync_request_completed)
	sync_requester.request("https://api.github.com/repos/kinoko0518/SQ-Academia/contents/Functions/Study/Lessons")
	#endregion
	
	$Main.visible = true
	
	#region Make default config when config file doens't exist
	if not FileAccess.file_exists("user://config.cfg"):
		var config = ConfigFile.new()
		
		config.set_value("global", "is_debug", false)
		config.set_value("global", "grade", 1)
		
		config.save("user://config.cfg")
	#endregion
	
	visible = true
	$SlideMenu.visible = true
	
	is_opening = false
	
	active_panel.anchor_left = 1
	active_panel.anchor_right = 2
	
	for _i in range(features.size()):
		var _temp = Button.new()
		_temp.button_down.connect(func hoge(): open_feature(features[_i].scene.instantiate()))
		_temp.text = features[_i].feature_name
		$Features/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/Features/Buttons.add_child(_temp)
	for _i in range(debug_features.size()):
		var _temp = Button.new()
		_temp.button_down.connect(func hoge(): open_feature(debug_features[_i].scene.instantiate()))
		_temp.text = debug_features[_i].feature_name
		$Features/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/DebugFeatures/Buttons.add_child(_temp)
	
	DirAccess.make_dir_recursive_absolute("user://Lessons")
	for _i in range(Lesson.Subjects.keys().size()):
		DirAccess.make_dir_recursive_absolute("user://Lessons/%s" % [Lesson.Subjects.keys()[_i]])

func _on_sync_request_completed(result, response_code, headers, body):
	pass
	# ResourceSaver.save(body)

func open_sidemenu():
	var _duration = 0.5
	var _tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	_tween.tween_property(active_panel, "anchor_left", 0, _duration)
	_tween.tween_property(active_panel, "anchor_right", 1, _duration)
	
	is_opening = true

func close_sidemenu():
	var _duration = 0.5
	var _tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	_tween.tween_property(active_panel, "anchor_left", 1, _duration)
	_tween.tween_property(active_panel, "anchor_right", 2, _duration)
	
	is_opening = false

func open_feature(target:Control):
	if not target == current_feature:
		for _i in range($Main.get_child_count()):
			$Main.get_child(_i).queue_free()
		
		$Main.add_child(target)
		current_feature = target
	if current_feature == null:
		return
	var _duration = 0.5
	var _tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	current_feature.anchor_top = 1
	current_feature.anchor_bottom = 2
	
	_tween.tween_property(current_feature, "anchor_top", 0, _duration)
	_tween.tween_property(current_feature, "anchor_bottom", 1, _duration)

func close_feature(target:Control):
	var _duration = 0.5
	var _tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	target.anchor_top = 0
	target.anchor_bottom = 1
	
	_tween.tween_property(target, "anchor_top", 1, _duration)
	_tween.tween_property(target, "anchor_bottom", 2, _duration)
	await _tween.finished

func _on_left_drugged():
	if not is_opening:
		open_sidemenu()

func _on_right_drugged():
	if is_opening:
		close_sidemenu()

func _on_down_drugged():
	if not current_feature == null: close_feature(current_feature)

func _on_up_drugged():
	open_feature(current_feature)
