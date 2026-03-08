class_name MacroXrDefaultMacroGroupEnterExitEmitter
extends MacroXrAbstractEmitter


@export var macro_array_enter:Array[String]
@export var macro_array_exit:Array[String]

func emit_stored_macro_for_entering_the_zone():
	emit_macro_array(macro_array_enter)
	
func emit_stored_macro_for_exiting_the_zone():
	emit_macro_array(macro_array_exit)
