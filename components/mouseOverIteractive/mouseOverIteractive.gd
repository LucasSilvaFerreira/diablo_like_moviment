extends Node3D
class_name MouseOverIteractive


@export var group_name = 'PlayerMouse'
@export var target_color = Vector4(255,0,0,0)
##case the player need a minimal distance to interact
@export var restricted_distance = false
##Define the distance in case restricted
@export var interaction_distance = 0.7
##needed to click to activate the mouse click
@export var click = true
## This will try to solve the distance problem case the objects are too far
@export var solving_not_reachable = true
@export var solver : Node

var selected  : Area3D
var distance_from_object : bool

signal on_select_unit(area3d, mouse_interactive)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	add_to_group(group_name)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
		
		
		

func distance_and_solver(distance, position, area3d):
	print ('distance of interactors ', distance)
	distance_from_object =  (distance <  interaction_distance)
	if  restricted_distance and not distance_from_object:
		print ('too distant... ', distance)
		if solving_not_reachable:
			
			solver.manual_solver_update_status(distance, position, area3d)
			print ('solving distance...')
			return true
	
	return false

func check_signal(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, area : Area3D) -> void:
	var distance = global_position.distance_to(area.global_position)

	
	if click:
		if event is InputEventMouseButton and event.pressed:
			if distance_and_solver(distance, area.global_position, area):
				return 
			else:
				print ('click')
				selected = area
				on_select_unit.emit(selected, self)
			
	else:
		if distance_and_solver(distance, area.global_position, area):
			
			return
		else:
			print ('else')
			selected = area
			on_select_unit.emit(selected, self)
		


	

	

	
