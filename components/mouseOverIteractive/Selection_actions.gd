extends Node
class_name SelectionActionsinterface
#This is a class interface to generate new interactive actiosn when the mouse is clicked on a 
#character
@export var mouse_iteraction: MouseOverIteractive


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	mouse_iteraction.on_select_unit.connect(actions_interface) 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func actions_interface(area3d, mouse_interactive):
	print ('rewrite  actions_interface')
