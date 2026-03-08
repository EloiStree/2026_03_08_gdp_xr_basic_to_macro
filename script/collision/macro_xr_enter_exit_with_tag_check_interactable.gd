
## Send him Array of Node from a collision filter and it trigger if the source is interacting or not.
class_name MacroXrArrayNodeSourceNodeInteractionListener
extends Node

## One of the source script just used press emit signal, used for example to trigger macro when pressing the zone
signal on_pressed_event_by_one_source_script()
## One of the source script just used release emit signal, used for example to trigger macro when releasing the zone
signal on_released_event_by_one_source_script()


signal on_pressed_event_with_source(source:MacroXrInteractionSource)
signal on_released_event_with_source(source:MacroXrInteractionSource)

## observing with update if at least one source script is requesting interaction, used for example to trigger macro while pressing the zone
signal on_one_source_interacting(is_interating:bool)
signal on_one_source_interacting_started()
signal on_one_source_interacting_ended()


## observing with update if one script of interaction is present
signal on_has_one_interactive_script_in_zone(has_one:bool)
## observing with update if one script of interaction is present
signal on_has_one_interactive_script_in_zone_started()
## observing with update if no script of interaction is present
signal on_has_one_interactive_script_in_zone_ended()

signal on_source_entered(node: MacroXrInteractionSource)
signal on_source_exited(node: MacroXrInteractionSource)

signal on_source_entered_while_beeing_interacting(node: MacroXrInteractionSource)
signal on_source_exited_while_beeing_interacting(node: MacroXrInteractionSource)


@export var valid_interactive_source_list: Dictionary[int,MacroXrInteractionSource] = {}
@export var is_one_source_actively_interacting: bool = false
@export var has_one_interactive_script_in_zone: bool = false
@export var use_debug_prints: bool = false

## Can be change and handle by a more slow script
@export var use_process_to_check_interaction_state: bool = true


func _process(delta: float) -> void:
	if not use_process_to_check_interaction_state:
		return
	
	check_interaction_state()

func check_interaction_state():
	var previous_is_one_source_actively_interacting = is_one_source_actively_interacting
	var previous_has_one_interactive_script_in_zone = has_one_interactive_script_in_zone

	is_one_source_actively_interacting = false
	has_one_interactive_script_in_zone = false

	for node in valid_interactive_source_list.values():
		if node != null:
			has_one_interactive_script_in_zone = true
			if node.is_requesting_interaction:
				is_one_source_actively_interacting = true
	# Remove empty
	var keys_to_remove = []
	for key in valid_interactive_source_list.keys():
		if valid_interactive_source_list[key] == null:
			keys_to_remove.append(key)
	for key in keys_to_remove:
		valid_interactive_source_list.erase(key)


	if previous_is_one_source_actively_interacting != is_one_source_actively_interacting:
		if use_debug_prints:
			print("One source interacting changed:", is_one_source_actively_interacting)
		on_one_source_interacting.emit(is_one_source_actively_interacting)
		if is_one_source_actively_interacting:
			on_one_source_interacting_started.emit()
		else:
			on_one_source_interacting_ended.emit()

	if previous_has_one_interactive_script_in_zone != has_one_interactive_script_in_zone:
		if use_debug_prints:
			print("Has one interactive script in zone changed:", has_one_interactive_script_in_zone)
		on_has_one_interactive_script_in_zone.emit(has_one_interactive_script_in_zone)
		if has_one_interactive_script_in_zone:
			on_has_one_interactive_script_in_zone_started.emit()
		else:
			on_has_one_interactive_script_in_zone_ended.emit()

func _on_valid_script_start_interacting():
	on_pressed_event_by_one_source_script.emit()
	
func _on_valid_script_stop_interacting():
	on_released_event_by_one_source_script.emit()

func _on_valid_script_start_interacting_with_source(source:MacroXrInteractionSource):
	on_pressed_event_with_source.emit(source)
	
func _on_valid_script_stop_interacting_with_source(source:MacroXrInteractionSource):
	on_released_event_with_source.emit(source)


func add_note_source_to_observe(found:Array[Node]):
	for script_node in found:
		if script_node!=null and script_node is MacroXrInteractionSource:
			var macro_script_node = script_node as MacroXrInteractionSource
			var instance_id = script_node.get_instance_id()
			if not valid_interactive_source_list.has(instance_id):
				if use_debug_prints:
					print("Valid source node entered:", script_node.get_source_display_name())
				on_source_entered.emit(script_node)
				if script_node.is_requesting_interaction:
					on_source_entered_while_beeing_interacting.emit(script_node)
				valid_interactive_source_list[instance_id] = script_node
				script_node.on_start_interacting.connect(_on_valid_script_start_interacting)
				script_node.on_stop_interacting.connect(_on_valid_script_stop_interacting)
				macro_script_node.on_start_interacting_with_source.connect(_on_valid_script_start_interacting_with_source)
				macro_script_node.on_stop_interacting_with_source.connect(_on_valid_script_stop_interacting_with_source)
				
	check_interaction_state()



func remove_note_source_to_observe(found:Array[Node]):
	for script_node in found:
		if script_node!=null and script_node is MacroXrInteractionSource:
			var instance_id = script_node.get_instance_id()
			var macro_script_node = script_node as MacroXrInteractionSource
			if valid_interactive_source_list.has(instance_id):
				if use_debug_prints:
					print("Valid source node exited:", script_node.get_source_display_name())
				on_source_exited.emit(script_node)
				if script_node.is_requesting_interaction:
					on_source_exited_while_beeing_interacting.emit(script_node)
				valid_interactive_source_list.erase(instance_id)
				script_node.on_start_interacting.disconnect(_on_valid_script_start_interacting)
				script_node.on_stop_interacting.disconnect(_on_valid_script_stop_interacting)
				macro_script_node.on_start_interacting_with_source.disconnect(_on_valid_script_start_interacting_with_source)
				macro_script_node.on_stop_interacting_with_source.disconnect(_on_valid_script_stop_interacting_with_source)
	check_interaction_state()
