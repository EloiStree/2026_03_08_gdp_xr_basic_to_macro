class_name MacroXrDefaultMacroGroupEmitter
extends MacroXrAbstractEmitter


@export var macro_array:Array[String]

func emit_stored_macro():
	emit_macro_array(macro_array)
