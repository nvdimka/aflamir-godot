extends CharacterBody2D

@export var ink: InkStory

var inkModal = preload("res://ui/ink_modal/InkModal.tscn")

var panel: Panel
var focus_label: Label

var is_player_near:
	get:
		return is_player_near
	set(value):
		panel.visible = value
		is_player_near = value

var is_focused:
	get:
		return is_focused
	set(value):
		focus_label.visible = value
		is_focused = value


func _ready():
	panel = $Panel
	focus_label = $Panel/FocusLabel
	
	is_player_near = false
	is_focused = false

# ! SIGNALS !

func _on_player_got_close() -> void:
	is_player_near = true

func _on_player_got_far() -> void:
	is_player_near = false

func _on_player_focused() -> void:
	is_focused = true


func _on_player_unfocused() -> void:
	is_focused = false


func _on_player_initiated_interaction() -> void:
	print("starting: ", ink)
	var inkModalNode = inkModal.instantiate()

	var text = ink.ContinueMaximally()

	inkModalNode.paragraphs = text
	
	self.add_child(inkModalNode)
