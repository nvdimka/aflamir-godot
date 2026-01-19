extends CharacterBody2D

@export var story: InkStory

@onready var ink_modal = Globals.player_node.get_ink_modal()

var action_sprite: Sprite2D


func change_ui_hints_visibility(value: bool):
	for icon in get_tree().get_nodes_in_group("actor_icons"):
		if value:
			icon.show()
		else:
			icon.hide()


func _ready():
	action_sprite = %ActionSprite


# ! SIGNALS !

func _on_player_got_close() -> void:
	action_sprite.texture = load("res://ui/icons/controls/empty_round.png")


func _on_player_got_far() -> void:
	action_sprite.texture = null


func _on_player_focused() -> void:
	action_sprite.texture = load("res://ui/icons/controls/gamepad_a.png")


func _on_player_unfocused() -> void:
	action_sprite.texture = load("res://ui/icons/controls/empty_round.png")


func _on_player_started_interaction() -> void:
	Globals.game_state = Globals.GameState.INTERACTION
	change_ui_hints_visibility(false)

	ink_modal.story = story
	ink_modal.show_next()
	ink_modal.show()


func _on_player_ended_interaction() -> void:
	Globals.game_state = Globals.GameState.EXPLORATION
	change_ui_hints_visibility(true)

	ink_modal.hide()
	story.ResetState()


func _on_scrolled_paragraphs(scroll_delta) -> void:
	ink_modal.Scroll.scroll_vertical += scroll_delta
