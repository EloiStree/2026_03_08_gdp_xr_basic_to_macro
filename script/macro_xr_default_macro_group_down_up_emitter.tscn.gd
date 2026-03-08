class_name MacroXrDefaultMacroGroupUsingEmitter
extends MacroXrAbstractEmitter


@export var macro_array_start_using:Array[String]
@export var macro_array_stop_using:Array[String]

func emit_stored_macro_for_pressing_the_zone():
	emit_macro_array(macro_array_start_using)
	
func emit_stored_macro_for_releasing_the_zone():
	emit_macro_array(macro_array_stop_using)
