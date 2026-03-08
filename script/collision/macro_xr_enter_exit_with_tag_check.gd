## Simply check if any body or area collision occured from the game engine.
class_name MacroXrEnterExitWithTagCheckArea3D
extends Node


signal on_valid_enter_event()
signal on_valid_exit_event()
signal on_valid_enter_event_with_source(source:Array[Node])
signal on_valid_exit_event_with_source(source:Array[Node])

@export var area3d_to_observe: Area3D
@export var allow_tag_scripts: Array[Script]
@export var use_debug_print:bool

func _ready():
	area3d_to_observe.body_entered.connect(_on_body_entered)
	area3d_to_observe.area_entered.connect(_on_area_entered)
	area3d_to_observe.body_exited.connect(_on_body_exited)
	area3d_to_observe.area_exited.connect(_on_area_exited)

func _on_body_entered(body):
	var script_nodes_found = _find_scripts_in_node_and_children(body)
	var has_valid_script = script_nodes_found.size() > 0
	if has_valid_script:
		if use_debug_print:
			print("Valid body entered:", body)
		on_valid_enter_event.emit()
		on_valid_enter_event_with_source.emit(script_nodes_found)

func _on_area_entered(area):
	var script_nodes_found = _find_scripts_in_node_and_children(area)
	var has_valid_script = script_nodes_found.size() > 0
	if has_valid_script:
		if use_debug_print:
			print("Valid area entered:", area)
		on_valid_enter_event.emit()
		on_valid_enter_event_with_source.emit(script_nodes_found)


func _on_body_exited(body):
	var script_nodes_found = _find_scripts_in_node_and_children(body)
	var has_valid_script = script_nodes_found.size() > 0
	if has_valid_script:
		if use_debug_print:
			print("Valid body exited:", body)
		on_valid_exit_event.emit()
		on_valid_exit_event_with_source.emit(script_nodes_found)

func _on_area_exited(area):
	var script_nodes_found = _find_scripts_in_node_and_children(area)
	var has_valid_script = script_nodes_found.size() > 0
	if has_valid_script:
		if use_debug_print:
			print("Valid area exited:", area)
		on_valid_exit_event.emit()
		on_valid_exit_event_with_source.emit(script_nodes_found)


func _find_scripts_in_node_and_children(node: Node)->Array[Node]:
	var list_of_nodes_found: Array[Node] = []
	if node.get_script() in allow_tag_scripts:
		list_of_nodes_found.append(node)
	for child in node.get_children():
		if child is Node:
			list_of_nodes_found += _find_scripts_in_node_and_children(child)
	
	return list_of_nodes_found
