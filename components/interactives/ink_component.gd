extends Node2D


@export var knot: String

@onready var ink_modal = Globals.player_node.get_node("%InkModal")


func _get_configuration_warning():
	if not knot:
		return 'knot not set'
	return ''


func start():
	Globals.game_state = Globals.GameState.INK
	Globals.hide_focus_sprites()
	ink_modal.start(knot)
	ink_modal.show()


func stop():
	Globals.game_state = Globals.GameState.EXPLORATION
	Globals.show_focus_sprites()
	ink_modal.hide()
	ink_modal.get_node("%Scroll").scroll_vertical = 0
