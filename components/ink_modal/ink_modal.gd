extends Control


var choice_idx: int
# TODO Сделать кастомную кнопку через TextureButton для возможности отрисовки маркдауна в кнопке
var choice_button_path = "res://components/ink_modal/InkChoice.tscn"

@onready var Paragraphs: MarkdownLabel = %Paragraphs
@onready var Scroll: ScrollContainer = %Scroll
@onready var ChoicesContainer = %ChoicesContainer

func start(knot: String):
	Globals.ink.ChoosePathString(knot)
	show_next()

# TODO вынести всю эту логику в ink_component. Здесь строго отображение текста и кнопок.
func show_next():
	clear_choices()
	var text = ""

	while Globals.ink.GetCanContinue():
		var new_paragraph = Globals.ink.Continue()
		if new_paragraph.begins_with(">"):
			new_paragraph = new_paragraph.remove_char(62) # removes ">"
			new_paragraph = new_paragraph.insert(0, "[indent]")
			new_paragraph = new_paragraph.insert(new_paragraph.length() - 1, "[/indent]")
		text += new_paragraph

	%Paragraphs.text = text
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
