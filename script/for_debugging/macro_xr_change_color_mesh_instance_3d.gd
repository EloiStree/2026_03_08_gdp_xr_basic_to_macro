class_name MacroXrChangeColorMeshInstance3D
extends Node

@export var mesh_instance_to_affect : Array[MeshInstance3D]
@export var state: bool = false : set = set_state
@export var true_color: Color = Color.GREEN
@export var false_color: Color = Color.RED

@export var apply_color_on_ready: bool = false

func _ready():
	if apply_color_on_ready:
		set_state(state)

func set_state(value: bool):
	state = value
	apply_color()
		
func set_state_as_true():
	set_state(true)
	apply_color()

func set_state_as_false():
	set_state(false)
	apply_color()

func apply_color():
	for mesh_instance in mesh_instance_to_affect:
		if mesh_instance == null or mesh_instance.get_active_material(0) == null:
			continue
		var material = mesh_instance.get_active_material(0)
		material.albedo_color = true_color if state else false_color
