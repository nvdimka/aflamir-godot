class_name Player

extends CharacterBody2D
@export var speed = 400

var areas = []
var focused_area:
	get:
		return focused_area
	set(new_area):
		for area in areas:
			if area == new_area:
				area.player_focused.emit()
			else:
				area.player_unfocused.emit()
		focused_area = new_area

func get_movement():
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed

func _input(event):
	# Selecting object to interact with
	if areas.size() > 0:
		if event.is_action_pressed("ui_right"):
			var idx = areas.find(focused_area)
			idx += 1
			if idx >= areas.size():
				idx = 0
			focused_area = areas[idx]
		if event.is_action_pressed("ui_left"):
			var idx = areas.find(focused_area)
			idx -= 1
			if idx < 0:
				idx = areas.size() - 1
			focused_area = areas[idx]
	
	if focused_area and event.is_action_pressed("accept"):
		focused_area.player_initiated_interaction.emit()


func _process(_delta):
	get_movement()
	move_and_slide()

# ! Signals !

func _on_npc_detection_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	add_area(area)

func add_area(area):
	areas.append(area)
	area.player_got_close.emit()
	if focused_area == null:
		focused_area = area
	
	
func _on_npc_detection_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	remove_area(area)
	
func remove_area(area):
	areas = areas.filter(func(a): return a != area)
	area.player_got_far.emit()
	area.player_unfocused.emit()
	if area == focused_area:
		focused_area = areas[0] if areas.size() > 0 else null
