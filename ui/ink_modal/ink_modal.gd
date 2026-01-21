extends Control


var choice_idx: int
var choice_button_path = "res://ui/ink_modal/ink_choice.tscn"

@onready var Paragraphs: MarkdownLabel = %Paragraphs
@onready var Scroll: ScrollContainer = %Scroll
@onready var ChoicesContainer = %ChoicesContainer

func start(knot: String):
	Globals.ink.ChoosePathString(knot)
	show_next()


func show_next():
	clear_choices()
	%Paragraphs.text = Globals.ink.ContinueMaximally()
	add_choices(Globals.ink.GetCurrentChoices())
	for choice in ChoicesContainer.get_children():
		# ставим фокус на первый новый выбор
		if not choice.is_queued_for_deletion():
			choice.grab_focus()
			break


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
	Globals.ink.ChooseChoiceIndex(idx)
	show_next()
