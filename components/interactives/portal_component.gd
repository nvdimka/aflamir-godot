@tool

extends Node2D


@export var PortalTarget: Node2D:
	set(new_PortalTarget):
		if new_PortalTarget != PortalTarget:
			PortalTarget = new_PortalTarget
			update_configuration_warnings()


func _get_configuration_warnings():
	var warnings = []

	if not PortalTarget:
		warnings.append("Please set `PortalTarget`.")

	# Returning an empty array means "no warning".
	return warnings


func start():
	var camera: Camera2D = Globals.player_node.get_node("%Camera")
	Globals.player_node.global_position = PortalTarget.global_position
	camera.reset_smoothing()