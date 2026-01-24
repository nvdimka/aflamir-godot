extends Sprite2D


func remove_texture():
	self.texture = null


func highlight():
	self.texture = load("res://ui/icons/controls/empty_round.png")


func focus():
	self.texture = load("res://ui/icons/controls/gamepad_a.png")


func _ready() -> void:
	remove_texture()