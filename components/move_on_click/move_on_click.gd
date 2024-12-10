extends Node
class_name MoveOnClick

@export var speed = 0.7
@export var gravity = -5
@export var tolerance = 0.1 as float

@export var scenario_mesh : StaticBody3D
@onready var marker_object : MeshInstance3D

@export_group('Nodes')
@export var character_body_3d : CharacterBody3D

signal click_detected(move_event)
const MARKER = preload("res://components/move_on_click/marker.tscn")

var target = Vector3.ZERO
var interrupt_moviment = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#the master from the whole scene   shoud have an scenario_mesh  variable

	scenario_mesh = scenario_mesh
	scenario_mesh.connect('input_event', on_scenario_input_event)
	marker_object = MARKER.instantiate()
	get_tree().current_scene.call_deferred("add_child", marker_object)
	




func _physics_process(delta):
	if not interrupt_moviment:
		character_body_3d.velocity.y += gravity * delta
		if target:
			character_body_3d.look_at(target, Vector3.UP)
			character_body_3d.rotation.x = 0
			character_body_3d.velocity = -character_body_3d.transform.basis.z * speed
			if character_body_3d.transform.origin.distance_to(target) < tolerance:
				target = Vector3.ZERO
				character_body_3d.velocity = Vector3.ZERO
				character_body_3d.animations.play('IDLE')
			else:
				character_body_3d.animations.play('RUN')

		
			character_body_3d.move_and_slide()
			#camera_moviment(camera_3d)
		
	
func on_scenario_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:

		if event is InputEventMouseButton and event.pressed:
			interrupt_moviment = false
			character_body_3d.enemy_selected = false
			character_body_3d.enemy_stored = null
			marker_object.transform.origin = position
			target = position
			click_detected.emit(self)
			
func manual_solver_update_status(distance, position , area3d):
	interrupt_moviment = false
	character_body_3d.enemy_selected = false
	character_body_3d.enemy_stored = null
	marker_object.transform.origin = position
	target = position
	
	
