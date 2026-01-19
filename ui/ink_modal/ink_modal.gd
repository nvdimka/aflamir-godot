extends Control


var story: InkStory

var choice_button_path = "res://ui/ink_modal/ink_choice.tscn"

@onready var Paragraphs: MarkdownLabel = %Paragraphs
@onready var Scroll: ScrollContainer = %Scroll
@onready var ChoicesContainer = %ChoicesContainer


func show_next():
	clear_choices()
	%Paragraphs.text = story.ContinueMaximally()
	add_choices(story.GetCurrentChoices())


func add_choices(new_choices: Array[InkChoice]):
	for idx in range(new_choices.size()):
		var button: Button = load(choice_button_path).instantiate()
		button.text = new_choices[idx].GetText()
		button.pressed.connect(on_selecting_choice.bind(idx))

		ChoicesContainer.add_child(button)

func clear_choices():
	for node in ChoicesContainer.get_children():
		node.queue_free()


func on_selecting_choice(idx: int):
	print(idx)
	story.ChooseChoiceIndex(idx)
	show_next()


func _input(_event) -> void:
	if Globals.game_state == Globals.GameState.INTERACTION:
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") and ChoicesContainer.get_child_count() > 0:
			var is_focused = ChoicesContainer.get_children().any(func(b: Button): return b.has_focus())

			if not is_focused:
				ChoicesContainer.get_child(0).grab_focus()
