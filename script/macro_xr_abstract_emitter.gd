class_name MacroXrAbstractEmitter
extends Node

signal on_macro_request(macro:String)

func emit_macro(macro:String)->void:
	on_macro_request.emit(macro)

func emit_macro_array( macros : Array[String] )->void:
	if macros ==null:
		return
	for macro in macros:
		emit_macro(macro)
	
