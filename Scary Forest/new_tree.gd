@tool
extends MeshInstance3D

@export var vertical_rings: int = 2
@export var ring_spacing: float = 0.5
@export var ring_radius: float = 1.0
@export_enum('Dots', 'Triangles') var mesh_mode: int

# Called when the node enters the scene tree for the first time.
func _ready():
	if mesh_mode == 0:
		make_dots()
	elif mesh_mode == 1:
		make_tris()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func make_dots():
	var arr_mesh = ArrayMesh.new()
	randomize()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var inds = PackedInt32Array()
	#var colors = PackedColorArray()
	
	for vrs in range(vertical_rings):
		var v = float(vrs)/vertical_rings
		var ring = PackedVector3Array()
		var angle = 0.0
		var height = vrs * ring_spacing
		for n in range(8):
			var u = float(n)/float(8)
			ring.append(Vector3(cos(angle),height,sin(angle))*ring_radius)
			uvs.append(Vector2(u,v))
			angle += PI/4
		verts.append_array(ring)

	surface_array[Mesh.ARRAY_VERTEX] = verts
#	surface_array[Mesh.ARRAY_INDEX] = inds
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
#	surface_array[Mesh.ARRAY_NORMAL] = normals
#	surface_array[Mesh.ARRAY_COLOR] = colors
#
#	# No blendshapes, lods, or compression used.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, surface_array)
#	#arr_mesh.regen_normal_maps()
	mesh = arr_mesh

func make_tris():
	var arr_mesh = ArrayMesh.new()
	randomize()
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	var verts = PackedVector3Array()
	var realverts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var inds = PackedInt32Array()
	#var colors = PackedColorArray()
	
	for vrs in range(vertical_rings):
		var v = float(vrs)/vertical_rings
		var ring = PackedVector3Array()
		var angle = 0.0
		var height = vrs * ring_spacing
		for n in range(8):
			var u = float(n)/float(8)
			ring.append(Vector3(cos(angle),height,sin(angle))*ring_radius)
			uvs.append(Vector2(u,v))
			angle += PI/4
		verts.append_array(ring)
		
	var results = triangulate_mesh(verts, 8)
	realverts = results[0]
	normals = results[1]

	surface_array[Mesh.ARRAY_VERTEX] = realverts
#	surface_array[Mesh.ARRAY_INDEX] = inds
	#surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
#	surface_array[Mesh.ARRAY_COLOR] = colors
#
#	# No blendshapes, lods, or compression used.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
#	#arr_mesh.regen_normal_maps()
	mesh = arr_mesh
	
func triangulate_mesh(arr: PackedVector3Array, looplen: int):
	var new_arr = PackedVector3Array()
	var norms = PackedVector3Array()
	var num = len(arr)-looplen-1
	print(num)
	for v in num:
		#v = v-1
#		if v == num:
#			pass
#		else:
		new_arr.append(arr[v])
		new_arr.append(arr[v+1])
		new_arr.append(arr[v+looplen])
		var pl = Plane(arr[v],arr[v+1],arr[v+looplen])
		norms.append(pl.normal)
		norms.append(pl.normal)
		norms.append(pl.normal)
		
		new_arr.append(arr[v+looplen])
		new_arr.append(arr[v+1])
		new_arr.append(arr[v+looplen+1])
		var pl2 = Plane(arr[v+looplen],arr[v+1],arr[v+looplen+1])
		norms.append(pl2.normal)
		norms.append(pl2.normal)
		norms.append(pl2.normal)
	return [new_arr, norms]

func generate_normals(verts, inds):
	var counter = 0
	var norms = PackedVector3Array()
	var buffer3 = PackedVector3Array()
	for i in inds:
		buffer3.append(verts[i])
		if counter == 2:
			counter = 0
			var pl = Plane(buffer3[0],buffer3[1],buffer3[2])
			for v in buffer3:
				norms.append(pl.normal.normalized())
			buffer3.clear()
		else:
			counter += 1
	return norms
