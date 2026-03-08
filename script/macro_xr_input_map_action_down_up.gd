class_name MacroXrInputMapActionDownUp
extends Node

signal on_down_up(pressed: bool)

@export var action_name: String
@export var listening_enabled:bool = true
@export var is_disable:bool =false

@export_group("For Debugging")
@export var input_state: bool = false
@export var debug_has_action_map_at_ready: bool = false

func _ready() -> void:
	if action_name.is_empty():
		push_warning("NesInputMapActionDownUp: action_name is empty.")
		return

	if not InputMap.has_action(action_name):
		push_error("NesInputMapActionDownUp: Input action '%s' does not exist." % action_name)
	debug_has_action_map_at_ready=true

func set_as_disable(value:bool):
	is_disable = value

func _input(event):
	if is_disable:
		return

	if not debug_has_action_map_at_ready:
		return 
		

	if not listening_enabled:
		return
	if action_name.is_empty():
		return
	if not InputMap.has_action(action_name):
		return
	if not event.is_action(action_name):
		return
	if event.is_pressed():
		input_state = true
		on_down_up.emit( true)
	else:
		input_state = false
		on_down_up.emit( false)
