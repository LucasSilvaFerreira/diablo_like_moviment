#@icon("res://components/icons/1484843.svg")
class_name StatusBarComponent

extends Sprite3D
@export_category("status properties")
@export var TOTAL_VALUE =10
@export var CURRENT_VALUE = 10
@export var VALUE_NAME = 'CUSTOM_VAR_NAME'
@export_category("status display") 
@export var status_bar:  ProgressBar
@export var view_port:  SubViewport
@export var color_display = 'red'
@export_category("vfx status")
@export var visual_effect= false
@export var shake_screen_on_impact = false
@export var camera : Camera3D
@export var word_enviroment : WorldEnvironment
@export_category("Actions on value zero")
@export var restart_scene_on_zero = false
@export var show_destroy_particle = false
@export var destroy_particle : GPUParticles3D
@export var destroy_car = false
@export var car_root_scene :  Node3D


@export_category("Generic on damage particle")
## test
## what is it
##

@export var generic_damage_vfx = false
## how about it
## and it
@export var particle_generic : GPUParticles3D
@export var particles_scale = 1.0
@export var particles_off_set : Vector3






func _ready():
	if show_destroy_particle:
		destroy_particle.finished.connect(playing_destruction_particle)
	
	
	print (status_bar)

	status_bar.max_value = TOTAL_VALUE
	status_bar.step=1
	status_bar.value = CURRENT_VALUE
	var style_box = status_bar.get("theme_override_styles/fill")
	style_box.bg_color = Color(color_display)

func playing_destruction_particle():
	print ('DEADDDDDDDDD')
	if destroy_car:
		car_root_scene.queue_free()
		
	

#render bar with the life in the futures
func add_value(amount):
	CURRENT_VALUE += amount
	status_bar.value = CURRENT_VALUE

func subtract_value(amount):
	#return is_dead
	CURRENT_VALUE -= amount
	status_bar.value = CURRENT_VALUE
	print ('Total ', VALUE_NAME, ' ', TOTAL_VALUE, ' Remaning: ', CURRENT_VALUE)
	if generic_damage_vfx:
		particle_generic.scale = Vector3(particles_scale, particles_scale, particles_scale)
		particle_generic.position = position
		particle_generic.position  += particles_off_set
		particle_generic.restart()
		
	if visual_effect:
		visual_effect_on_hit()
		
		
	if CURRENT_VALUE >0:
		return false
	else:
		print ('zero on this status')
		if show_destroy_particle:
			print ('HARDCODED UGLY TEST...CHANGE IT AND ADD THIS EXPLOSION AS A SKILL')
			print ('Create a descent explosion for the car using 3d particles for tire, iron, and fire')
			destroy_particle.get_child(0).visible = true
			destroy_particle.restart()
			
		if destroy_car and not show_destroy_particle:
			car_root_scene.queue_free()
			 
		if restart_scene_on_zero:
			get_tree().reload_current_scene()

		return true



func visual_effect_on_hit():
	var tween = get_tree().create_tween()
	print(word_enviroment.environment.tonemap_white)
	if  shake_screen_on_impact:
		tween.tween_property(camera, 'position', camera.position + Vector3(-0.1,0.1,0), 0.000016).from_current()
		tween.tween_property(camera, "position", camera.position + Vector3(0.1,-0.1,0), 0.000016).from_current()
		
		
		
	tween.tween_property(word_enviroment.environment, "tonemap_white", 0.05, 0.05)
	tween.tween_property(word_enviroment.environment, "tonemap_white", 1, 0.1)
	
	
	tween.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
