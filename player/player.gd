extends CharacterBody2D

class_name Player


@export var speed = 400
@export var scrolling_speed = 4
@export var camera_offset_delta = 400


func get_movement():
	velocity.x = Input.get_vector("move_left", "move_right", "move_up", "move_down").x * speed
	velocity.y = Input.get_vector("move_left", "move_right", "move_up", "move_down").y * (speed / 1.5)


func get_right_joy() -> Vector2:
	return Input.get_vector("right_joy_left", "right_joy_right", "right_joy_up", "right_joy_down")


func process_camera_with_joy():
	var offset = get_right_joy() * camera_offset_delta
	%Camera.offset = lerp(%Camera.offset, offset, 0.025)


func process_start_interaction(event: InputEvent):
	var interactive = Globals.get_focused_interactive()
	if event.is_action_released("accept") and interactive:
		interactive.start()

func process_stop_interaction(event: InputEvent):
	var interactive = Globals.get_focused_interactive()
	if event.is_action_released("back") and interactive:
		interactive.stop()


func process_scrolling_ink():
	var scroll_delta = get_right_joy().y * scrolling_speed
	%InkModal.get_node("%Scroll").scroll_vertical += scroll_delta


func process_interactive_selection(event: InputEvent) -> void:
	# ! Selecting actor to interact with
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		var interactives = Globals.get_all_near_interactives()
		if interactives.size() > 0:
			var idx = interactives.find(Globals.get_focused_interactive())
			var next_idx: int

			if event.is_action_pressed("ui_right"):
				next_idx = idx + 1
				if next_idx >= interactives.size():
					next_idx = 0
			if event.is_action_pressed("ui_left"):
				next_idx = idx - 1

			interactives[idx].is_focused = false
			interactives[next_idx].is_focused = true


func _ready() -> void:
	Globals.player_node = self


func _input(event: InputEvent) -> void:
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			process_interactive_selection(event)
			process_start_interaction(event)
		Globals.GameState.INK:
			process_stop_interaction(event)


func _process(_delta):
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			get_movement()
			move_and_slide()
			process_camera_with_joy()
		Globals.GameState.INK:
			process_scrolling_ink()
