
class_name MacroXrInteractionSource
extends Node

signal on_start_interacting()
signal on_stop_interacting()
signal on_start_interacting_with_source(source:MacroXrInteractionSource)
signal on_stop_interacting_with_source(source:MacroXrInteractionSource)
signal on_interacting_state_changed(value:bool)
signal on_interacting_state_changed_with_source(value:bool, source:MacroXrInteractionSource)


## Used for debugging and editor display, not used for logic
@export var source_display_name: String

## Used by developer to check what is the source type
@export var source_code_id_name: String

## Used to make research on the children of the source
@export var source_root_node: Node3D

## Allows to create basic interaction with objects.
@export var is_requesting_interaction : bool



func get_source_display_name()->String:
	return source_display_name

func get_source_code_id_name()->String:
	return source_code_id_name

func get_source_root_node()->Node3D:
	return source_root_node

func set_requesting_interaction_as_true ()->void:
	set_requesting_interaction_as(true)

func set_requesting_interaction_as_false ()->void:
	set_requesting_interaction_as(false)

func set_requesting_interaction_as(using_state: bool )->void:
	var previous_value = is_requesting_interaction
	is_requesting_interaction=using_state
	var changed = previous_value !=using_state
	if changed:
		if using_state:
			on_start_interacting.emit()
			on_interacting_state_changed.emit(true)
			var source:MacroXrInteractionSource = self
			on_start_interacting_with_source.emit(source)
		else:
			on_stop_interacting.emit()
			on_interacting_state_changed.emit(false)
			var source:MacroXrInteractionSource = self
			on_stop_interacting_with_source.emit(source)
			
