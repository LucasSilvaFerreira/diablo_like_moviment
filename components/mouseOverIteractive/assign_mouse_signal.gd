extends Node3D
class_name AssignMouseSignal

@export var detectionArea3D: Area3D
@export var group_detection = 'PlayerMouse'
##stores the nodes that have the selected signal, important to capture when the signal is trigged
## and validates
signal local_signal(mouse_interaction)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for g_detect in get_tree().get_nodes_in_group(group_detection):
		print (g_detect.name)
		#detectionArea3D.mouse_entered.connect(g_detect.check_signal.bind(detectionArea3D))
		detectionArea3D.input_event.connect(g_detect.check_signal.bind(detectionArea3D))
		g_detect.on_select_unit.connect(_local_signal_test)
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _process(delta: float) -> void:
	pass


func _local_signal_test(area3d: Area3D, mouse_interaction: MouseOverIteractive):
	print ('selected ', area3d, detectionArea3D)
	if area3d == detectionArea3D:
		print ('detecting')
		local_signal.emit(mouse_interaction)
