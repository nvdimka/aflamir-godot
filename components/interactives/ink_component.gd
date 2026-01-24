@tool

extends Node2D

@onready var ink_modal

@export var knot: String:
	set(new_val):
		if knot != new_val:
			knot = new_val
			update_configuration_warnings()


func _get_configuration_warnings():
	if not knot:
		return ['`knot` not set']
	return []


func _ready() -> void:
	if not Engine.is_editor_hint():
		ink_modal = Globals.player_node.get_node("%InkModal")


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
