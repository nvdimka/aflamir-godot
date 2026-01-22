extends Node

var player_node: Player

enum GameState {EXPLORATION, INK, INVENTORY}
var game_state: GameState = GameState.EXPLORATION


@onready var ink = load("res://inks/_main.ink")


func add_to_near_interactives(node: Node2D):
	node.add_to_group("interactives_near_player")


func remove_from_near_interactives(node: Node2D):
	node.remove_from_group("interactives_near_player")


func get_all_near_interactives() -> Array[Node]:
	return get_tree().get_nodes_in_group("interactives_near_player")


func get_focused_interactive() -> Node:
	var interactives = get_all_near_interactives()

	if (interactives.size() == 0):
		return null

	var idx = interactives.find_custom(func(elem: Node): return elem.is_focused)
	if idx >= 0:
		return interactives[idx]
	else:
		return null


func show_focus_sprites():
	for icon in get_tree().get_nodes_in_group("focus_sprites"):
		icon.show()


func hide_focus_sprites():
	for icon in get_tree().get_nodes_in_group("focus_sprites"):
		icon.hide()