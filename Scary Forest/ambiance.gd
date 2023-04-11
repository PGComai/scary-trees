@tool
extends WorldEnvironment

@onready var spot_light_3d = $"../Player/SpotLight3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spot_light_3d.visible:
		environment.fog_density = lerp(environment.fog_density, 0.04, 0.002)
		environment.fog_sky_affect = lerp(environment.fog_sky_affect, 1.0, 0.02)
	else:
		environment.fog_density = lerp(environment.fog_density, 0.001, 0.02)
		environment.fog_sky_affect = lerp(environment.fog_sky_affect, 0.5, 0.001)
