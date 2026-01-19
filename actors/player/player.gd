class_name Player


extends CharacterBody2D
@export var speed = 400
@export var scrolling_speed = 4


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

func get_scrolling() -> float:
	return Input.get_axis("scroll_up", "scroll_down")

func _input(event):
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			# ! Selecting actor to interact with
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
				focused_area.player_started_interaction.emit()

		Globals.GameState.INTERACTION:
			# TODO delete
			if focused_area and event.is_action_pressed("back"):
				focused_area.player_ended_interaction.emit()
			

func _process(_delta):
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			get_movement()
			move_and_slide()
		Globals.GameState.INTERACTION:
			if focused_area:
				var scroll_delta = get_scrolling() * scrolling_speed
				focused_area.scrolled_paragraphs.emit(scroll_delta)


# ! SIGNALS !

func _on_npc_detection_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	areas.append(area)
	area.player_got_close.emit()
	if focused_area == null:
		focused_area = area
	
	
func _on_npc_detection_area_shape_exited(_area_rid: RID, area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	areas = areas.filter(func(a): return a != area)
	area.player_unfocused.emit()
	area.player_got_far.emit()
	if area == focused_area:
		focused_area = areas[0] if areas.size() > 0 else null


func get_ink_modal() -> Node:
	return %InkModal


func _ready() -> void:
	Globals.player_node = self