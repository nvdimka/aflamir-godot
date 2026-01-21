extends CharacterBody2D

class_name Player


@export var speed = 400
@export var scrolling_speed = 4


func _input(event: InputEvent) -> void:
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			process_inkable_selection(event)
			process_start_interaction(event)
		Globals.GameState.INTERACTION:
			process_stop_interaction(event)


func _process(_delta):
	match Globals.game_state:
		Globals.GameState.EXPLORATION:
			get_movement()
			move_and_slide()
		Globals.GameState.INTERACTION:
			process_scrolling_ink()


func get_movement():
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed

func get_scrolling() -> float:
	return Input.get_axis("scroll_up", "scroll_down")


func process_start_interaction(event: InputEvent):
	var inkable = Utils.get_focused_inkable()
	if event.is_action_released("accept") and inkable:
		inkable.start_interaction()

func process_stop_interaction(event: InputEvent):
	var inkable = Utils.get_focused_inkable()
	if event.is_action_released("back") and inkable:
		inkable.stop_interaction()


func process_scrolling_ink():
	var scroll_delta = get_scrolling() * scrolling_speed
	%InkModal.get_node("%Scroll").scroll_vertical += scroll_delta


func process_inkable_selection(event: InputEvent) -> void:
	# ! Selecting actor to interact with
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_left"):
		var inkables = Utils.get_all_near_inkables()
		if inkables.size() > 0:
			var idx = inkables.find_custom(Utils.find_focused.bind())
			var next_idx: int

			if event.is_action_pressed("ui_right"):
				next_idx = idx + 1
				if next_idx >= inkables.size():
					next_idx = 0
			if event.is_action_pressed("ui_left"):
				next_idx = idx - 1

			inkables[idx].is_focused = false
			inkables[next_idx].is_focused = true


# TODO do i need to do this?
func _ready() -> void:
	Globals.player_node = self
