extends Control

@export var paragraphs: String:
	get:
		return paragraphs
	set(value):
		paragraphs = value
		$Paragraphs.text = paragraphs

func _ready() -> void:
	$Paragraphs.text = paragraphs