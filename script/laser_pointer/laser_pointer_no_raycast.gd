class_name LaserPointerNoRaycast
extends Node3D

# The node from which the laser originates
@export var origin_node: Node3D

# Beam parameters
@export var beam_radius: float = 0.02
@export var beam_length: float = 5.0
@export var beam_color: Color = Color.RED
@export var direction: Vector3 = Vector3.FORWARD

# Existing nodes assigned in the editor
@export var root_to_move: Node3D
@export var mesh_instance: MeshInstance3D
@export var collision_shape: CollisionShape3D

func _ready() -> void:
	if not origin_node:
		push_error("No origin_node assigned for laser!")
		return
	if not mesh_instance or not collision_shape:
		push_error("Assign mesh_instance and collision_shape in the editor!")
		return

	# --- Configure the mesh ---
	if mesh_instance.mesh is CylinderMesh:
		var mesh := mesh_instance.mesh as CylinderMesh
		mesh.top_radius = beam_radius
		mesh.bottom_radius = beam_radius
		mesh.height = beam_length

	var mat := mesh_instance.get_active_material(0)
	if mat is StandardMaterial3D:
		var material := mat as StandardMaterial3D
		material.albedo_color = beam_color
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		material.flags_unshaded = true
		material.flags_transparent = true
		material.render_priority = 1  # Ensure it renders on top
	

	# --- Configure the collision shape ---
	if collision_shape.shape is CylinderShape3D:
		var shape := collision_shape.shape as CylinderShape3D
		shape.radius = beam_radius
		shape.height = beam_length



	# --- Position and orient the beam ---
	mesh_instance.global_position = origin_node.global_position
	collision_shape.global_position = origin_node.global_position
	

	
	var to_move = root_to_move if root_to_move else self
	var global_laser_position = origin_node.global_position + direction.normalized() * (beam_length / 2)
	var laser_rotation = basis.get_euler()
	
	to_move.global_position = global_laser_position
	to_move.global_rotation = laser_rotation


	## scale the mesh and collision to match the beam length

	if mesh_instance.mesh is CylinderMesh:
		var mesh := mesh_instance.mesh as CylinderMesh
		mesh.height = beam_length
		mesh.top_radius = beam_radius
		mesh.bottom_radius = beam_radius
	if collision_shape.shape is CylinderShape3D:
		var shape := collision_shape.shape as CylinderShape3D
		shape.height = beam_length
		shape.radius = beam_radius
		

	
