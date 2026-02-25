@tool

extends Node2D

@onready var ink_modal

@export var knot: String:
	set(new_val):
		if knot != new_val:
			knot = new_val
			update_configuration_warnings()


var choice_button_path = "res://components/ink_modal/InkChoiceButton.tscn"


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
	Globals.ink.ChoosePathString(knot)
	show_next()
	ink_modal.show()


func stop():
	Globals.game_state = Globals.GameState.EXPLORATION
	Globals.show_focus_sprites()
	ink_modal.hide()
	ink_modal.get_node("%Scroll").scroll_vertical = 0


# Ink controls

func show_next():
	var text = ""

	while Globals.ink.GetCanContinue():
		var new_paragraph = Globals.ink.Continue()
		text += new_paragraph

	ink_modal.get_node("%Paragraphs").text = text
	var choices = Globals.ink.GetCurrentChoices()
	print(choices)
	if choices:
		add_choices(choices)
	

func add_choices(new_choices: Array[InkChoice]):
	clear_choices()
	for idx in range(new_choices.size()):
		var ink_choice = load(choice_button_path).instantiate()
		var button: Button = ink_choice.get_node("%Button")
		var label: MarkdownLabel = ink_choice.get_node("%Label")

		label.markdown_text = new_choices[idx].GetText()
		button.pressed.connect(on_selecting_choice.bind(idx))
		ink_modal.get_node("%ChoicesContainer").add_child(ink_choice)
	
	for choice in ink_modal.get_node("%ChoicesContainer").get_children():
		# ставим фокус на первый новый выбор
		if not choice.is_queued_for_deletion():
			choice.get_node("%Button").grab_focus()
			break


func clear_choices():
	for node in ink_modal.get_node("%ChoicesContainer").get_children():
		node.queue_free()


func on_selecting_choice(idx: int):
	Globals.ink.ChooseChoiceIndex(idx)
	show_next()
