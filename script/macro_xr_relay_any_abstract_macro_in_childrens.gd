class_name MacroXrRelayAnyAbstractMacroInChildrens
extends Node

signal on_macro_requested(macro_relayed:String)

@export var parent_note_to_overwatch:Array[Node]

@export_group("For Debugging")
@export var all_macro_emitter_found :Array[MacroXrAbstractEmitter]
@export var last_relayed_value:String

func _find_all_emitter_in_nodes(nodes: Array[Node]) -> Array[MacroXrAbstractEmitter]:
	var result: Array[MacroXrAbstractEmitter] = []
	# use of recursivity
	for node in nodes:
		if node is NesAbstractMacroEmitter:
			result.append(node)
		if node.get_child_count() > 0:
			result.append_array(
				_find_all_emitter_in_nodes(node.get_children())
			)
	return result

func _ready() -> void:
	# Look in the children of the node given for macro emitters
	var enitters :Array[MacroXrAbstractEmitter]= _find_all_emitter_in_nodes(parent_note_to_overwatch)
	all_macro_emitter_found  = enitters
	for emit in enitters:
		emit.on_any_macro_emit.connect(_relay_macro)

func _relay_macro(value_to_relay:String):
	on_macro_requested.emit(value_to_relay)
	last_relayed_value =str(value_to_relay)
	
	
	
