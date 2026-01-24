@tool

extends Area2D

@export var InteractionComponent: Node2D:
	set(new_InteractionComponent):
		if new_InteractionComponent != InteractionComponent:
			InteractionComponent = new_InteractionComponent
			update_configuration_warnings()
@export var FocusSprite: Sprite2D:
	set(new_FocusSprite):
		if new_FocusSprite != FocusSprite:
			FocusSprite = new_FocusSprite
			update_configuration_warnings()


func _get_configuration_warnings():
	var warnings = []

	if not InteractionComponent:
		warnings.append("Please set `InteractionComponent`.")

	if not FocusSprite:
		warnings.append("Please set `FocusSprite`.")

	# Returning an empty array means "no warning".
	return warnings


var is_focused := false:
	set(val):
		is_focused = val
		if val:
			FocusSprite.focus()
		else:
			FocusSprite.highlight()


func _on_player_entered(_body: Node2D) -> void:
	FocusSprite.highlight()
	Globals.add_to_near_interactives(self)
	if Globals.get_all_near_interactives().size() == 1:
		self.is_focused = true


func _on_player_exited(_body: Node2D) -> void:
	self.is_focused = false
	FocusSprite.remove_texture()
	Globals.remove_from_near_interactives(self)
	if Globals.get_focused_interactive() == null && Globals.get_all_near_interactives().size() > 0:
		var lastInteractive = Globals.get_all_near_interactives()[-1]
		lastInteractive.is_focused = true


func start():
	if InteractionComponent.has_method("start"):
		InteractionComponent.start()


func stop():
	if InteractionComponent.has_method("stop"):
		Globals.game_state = Globals.GameState.EXPLORATION
		InteractionComponent.stop()
