@tool
extends OmniLight3D

@onready var spot_light_3d = $"../SpotLight3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spot_light_3d.visible:
		light_energy = lerp(light_energy, 0.0, 0.2)
	else:
		light_energy = lerp(light_energy, 0.03, 0.001)
