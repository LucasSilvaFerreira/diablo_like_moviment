extends CharacterBody3D


#@export var speed = 0.7
#@export var gravity = -5
## Attach your camera3d that will follow the player
@export var camera_3d: Camera3D 
@export var camera_x_offset  = 0.22 as float
@export var camera_z_offset  = -1.0 as float
## Add a mesh that will mark the clicked place, add animations to make it looks better
#@export var marker_object : MeshInstance3D
## This is the scenario representing your scenario. This should have a collisionshape3d to map the scenario 
#@export var scenario_mesh : StaticBody3D

@export var tolerance = 0.5 as float
# character animation
@export var animations : AnimationPlayer
# character slash
@export var slash_animation : AnimationPlayer
@export var hit_frame_in_second : float =  1.0
@export var slash_sound : AudioStreamPlayer3D
@export var movement : MoveOnClick


var enemy_selected = false
var enemy_stored : Area3D
var timer_attack : Timer
#var target = Vector3.ZERO

func _ready() -> void:
	#register
	pass

	#scenario_mesh.connect('input_event', on_scenario_input_event)


func _process(delta):
	
	hit_animation(animations.current_animation)
	
func _physics_process(delta):

	camera_moviment(camera_3d)



func flash_animation():
		# Start value (original shader parameter value)
	var original_color: Vector4 = Vector4(0, 0, 0, 0)
	# Target value to tween to
	var target_color: Vector4 = Vector4(40,40, 40, 1)

	var mesh_to_material = enemy_stored.mesh as MeshInstance3D
	enemy_stored.audioOnHit.pitch_scale = randf_range(0.7, 1.3)
	enemy_stored.audioOnHit.play() #playing audio
	var particle_on_hit = enemy_stored.NodeWithParticle.get_node('GPUParticles3D') as GPUParticles3D
	particle_on_hit.emitting=true
	particle_on_hit.restart()
	#drop

	enemy_stored.dropItem.drop()
	var tween = get_tree().create_tween()

	var hit_message = Label3DAnimate.new()
	hit_message.text = '10'
	hit_message.name = 'labelhit'
	hit_message.scale_text = 0.3
	hit_message.amount = 0.1
	add_child(hit_message)
	hit_message.global_position = enemy_stored.global_position
	
	tween.tween_method( func(value): mesh_to_material.get_active_material(0).set_shader_parameter("color", value),  
 original_color,  # Start value
  target_color,  # End value
  0.3     # Duration
);
	tween.tween_method( func(value): mesh_to_material.get_active_material(0).set_shader_parameter("color", value),  
 target_color,  # Start value
  original_color,  # End value
  0.1     # Duration
)
	tween.tween_callback(damage_iteractive.bind(10))


func damage_iteractive(amount):

	enemy_stored.status_bar_component.subtract_value(amount)
	print (enemy_stored.status_bar_component.CURRENT_VALUE )
	if enemy_stored.status_bar_component.CURRENT_VALUE <= 0:
		animations.play('IDLE')
		enemy_selected = false
		enemy_stored = null
		
		
func hit_animation(anim_name):
	#print (anim_name)
	if anim_name == 'ATTACK':
		if roundf(animations.current_animation_position * 100) == roundf(hit_frame_in_second * 100):
				enemy_stored.animation_player.play("DAMAGE")
				flash_animation()
				slash_animation.play('slash')			
				slash_sound.pitch_scale = randf_range(0.7, 1.3)
				slash_sound.play()


func camera_moviment(camera):
	camera.position.x = position.x - (camera_x_offset )
	camera.position.z = position.z - (camera_z_offset )
	
