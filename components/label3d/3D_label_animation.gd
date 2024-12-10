extends Label3D
class_name Label3DAnimate
@export var amount = 0.3
@export var velocity = 0.4
@export var execute_test = false
@export var range_random = 30
@export var initial_scale = 0.5
@export var scale_text = 0.5
@export var random_scale_delta = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#billboard = 1
	scale = Vector3(initial_scale, initial_scale, initial_scale)
	tween_movement()
	
func tween_movement():
	var rng = RandomNumberGenerator.new()
	var random_add_variance = rng.randf_range(-range_random, range_random)
	rotation_degrees.z = random_add_variance
	var  random_scale_factor =  rng.randf_range(0.4, 1) * random_scale_delta
	var tween = get_tree().create_tween()
	amount = amount * random_scale_factor

	tween.parallel().tween_property(self ,"global_position:y", amount, velocity ).as_relative().set_trans(Tween.TRANS_SINE)

	tween.parallel().tween_property(self ,"scale", Vector3(random_scale_factor * scale_text, random_scale_factor * scale_text,random_scale_factor * scale_text), velocity ).as_relative().set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self ,"modulate:a", 0, velocity*3 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self ,"outline_modulate:a", 0, velocity*3 ).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(destroy)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print (execute_test)
	if execute_test:
		execute_test = false
		tween_movement() 
		
func destroy():

	queue_free()
