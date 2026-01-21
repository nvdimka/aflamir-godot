extends Area2D

@export var knot: String
@export var focus_sprite: Sprite2D

@onready var ink_modal = Globals.player_node.get_node("%InkModal")


func _get_configuration_warning():
	if not knot:
		return 'knot not set'
	if not focus_sprite:
		return 'focus_sprite not set'
	return ''


var is_focused := false:
	get:
		return is_focused
	set(val):
		is_focused = val
		if val:
			focus_sprite.focus()
		else:
			focus_sprite.unfocus()


func _on_player_entered(_body: Node2D) -> void:
	focus_sprite.show()
	self.add_to_group("inkables_near_player")
	if Utils.get_all_near_inkables().size() == 1:
		self.is_focused = true


func _on_player_exited(_body: Node2D) -> void:
	focus_sprite.hide()
	self.is_focused = false
	self.remove_from_group("inkables_near_player")
	if (not Utils.get_all_near_inkables().any(Utils.find_focused)
		&& Utils.get_all_near_inkables().size() > 0):
		Utils.get_all_near_inkables()[-1].is_focused = true


func start_interaction():
	Globals.game_state = Globals.GameState.INTERACTION
	for icon in get_tree().get_nodes_in_group("inkable_focus_sprites"):
		icon.hide()
	ink_modal.start(knot)
	ink_modal.show()


func stop_interaction():
	Globals.game_state = Globals.GameState.EXPLORATION
	for icon in get_tree().get_nodes_in_group("inkable_focus_sprites"):
		icon.show()
	ink_modal.hide()
	ink_modal.get_node("%Scroll").scroll_vertical = 0
