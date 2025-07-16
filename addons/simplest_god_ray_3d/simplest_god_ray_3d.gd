@tool
class_name SimplestGodRay3D
extends Node3D

# ──────────────────────────────────────────────
# Exported parameters
@export_range(0.1, 10.0) var width: float = 1.0:
	set(value):
		width = value
		if is_inside_tree(): call_deferred("_update_mesh")

@export_range(0.1, 10.0) var height: float = 3.0:
	set(value):
		height = value
		if is_inside_tree(): call_deferred("_update_mesh")

@export_range(0.0, 5.0) var spread: float = 1.0:
	set(value):
		spread = value
		if is_inside_tree(): call_deferred("_update_material")

@export_range(0.0, 10.0) var intensity: float = 1.0:
	set(value):
		intensity = value
		if is_inside_tree(): call_deferred("_update_material")

@export_range(0.0, 1.0) var transparency: float = 1.0:
	set(value):
		transparency = value
		if is_inside_tree(): call_deferred("_update_material")

@export_range(0.1, 10.0) var fade_distance: float = 1.0:
	set(value):
		fade_distance = value
		if is_inside_tree(): call_deferred("_update_material")

@export var ray_color: Color = Color(1.0, 1.0, 0.8, 1.0):
	set(value):
		ray_color = value
		if is_inside_tree(): call_deferred("_update_material")

@export_flags_3d_render var visibility_layers: int = 1:
	set(value):
		visibility_layers = value
		if is_inside_tree(): call_deferred("_update_visibility")

# ──────────────────────────────────────────────
# Internal
var mesh_instance: MeshInstance3D
var material: ShaderMaterial = ShaderMaterial.new()

# ──────────────────────────────────────────────
# Life Cycle
func _ready():
	_ensure_mesh_instance()
	_update_mesh()
	_update_material()
	_update_visibility()

func _notification(what):
	if what == NOTIFICATION_READY and Engine.is_editor_hint():
		_ensure_mesh_instance()
		_update_mesh()
		_update_material()
		_update_visibility()

func _process(_delta):
	if Engine.is_editor_hint():
		_ensure_mesh_instance()
		_update_material()
		_update_visibility()

# ──────────────────────────────────────────────
# Internal methods
func _ensure_mesh_instance():
	# Si ya existe y es válido, salir
	if is_instance_valid(mesh_instance):
		return

	# Buscar si ya hay uno
	for child in get_children():
		if child is MeshInstance3D:
			mesh_instance = child
			return

	# Si no hay, crear uno nuevo
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)

func _update_mesh():
	if not is_instance_valid(mesh_instance):
		return
	var quad := QuadMesh.new()
	quad.size = Vector2(width, height)
	mesh_instance.mesh = quad
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func _update_material():
	if not is_instance_valid(mesh_instance):
		return
	var shader := load("res://addons/simplest_god_ray_3d/shaders/god_ray_mesh.gdshader")
	material.shader = shader
	material.set_shader_parameter("spread", spread)
	material.set_shader_parameter("intensity", intensity)
	material.set_shader_parameter("transparency", transparency)
	material.set_shader_parameter("fade_distance", fade_distance)
	material.set_shader_parameter("ray_color", ray_color)
	mesh_instance.material_override = material

func _update_visibility():
	if is_instance_valid(mesh_instance):
		mesh_instance.layers = visibility_layers
