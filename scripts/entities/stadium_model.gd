extends Node3D
class_name StadiumModel

# StadiumModel: AAA International Cricket Arena (WCC3 / RC24 Console Visuals)
# Features: Regulation 22-Yard Clay/Turf Pitch, Lawn Mower Turf Rings, LED Boundary Boards,
# Sight Screens, 4 Floodlight Pylons & 3-Tier Packed Grandstands.

@export var boundary_radius: float = 68.0

var outfield_root: Node3D
var pitch_mesh: MeshInstance3D
var boundary_root: Node3D
var grandstands_root: Node3D
var floodlights_root: Node3D
var sight_screens_root: Node3D

var pitch_mat: StandardMaterial3D
var grass_mat_dark: StandardMaterial3D
var grass_mat_light: StandardMaterial3D
var crease_mat: StandardMaterial3D
var led_mat: StandardMaterial3D
var rope_mat: StandardMaterial3D
var stand_mat: StandardMaterial3D
var crowd_mat: StandardMaterial3D

func _ready() -> void:
	_init_materials()
	_build_mowed_outfield()
	_build_pitch()
	_build_crease_lines()
	_build_boundary_rope_and_led_boards()
	_build_sight_screens()
	_build_grandstands_and_crowd()
	_build_floodlight_towers()
	update_pitch_material(GameManager.selected_pitch)

func _init_materials() -> void:
	# Grass materials (Concentric alternating lawn mower stripes)
	grass_mat_dark = StandardMaterial3D.new()
	grass_mat_dark.albedo_color = Color(0.14, 0.42, 0.16)
	grass_mat_dark.roughness = 0.82
	if ResourceLoader.exists("res://assets/textures/pbr/turf_2k_albedo.png"):
		grass_mat_dark.albedo_texture = load("res://assets/textures/pbr/turf_2k_albedo.png")
		grass_mat_dark.normal_enabled = true
		grass_mat_dark.normal_texture = load("res://assets/textures/pbr/turf_2k_normal.png")
		grass_mat_dark.roughness_texture = load("res://assets/textures/pbr/turf_2k_roughness.png")
		grass_mat_dark.uv1_scale = Vector3(8, 8, 1)

	grass_mat_light = StandardMaterial3D.new()
	grass_mat_light.albedo_color = Color(0.18, 0.49, 0.20)
	grass_mat_light.roughness = 0.80
	if ResourceLoader.exists("res://assets/textures/pbr/turf_2k_albedo.png"):
		grass_mat_light.albedo_texture = load("res://assets/textures/pbr/turf_2k_albedo.png")
		grass_mat_light.normal_enabled = true
		grass_mat_light.normal_texture = load("res://assets/textures/pbr/turf_2k_normal.png")
		grass_mat_light.roughness_texture = load("res://assets/textures/pbr/turf_2k_roughness.png")
		grass_mat_light.uv1_scale = Vector3(8, 8, 1)

	# 22-Yard Pitch Surface
	pitch_mat = StandardMaterial3D.new()
	pitch_mat.albedo_color = Color(0.72, 0.62, 0.44)
	pitch_mat.roughness = 0.72
	if ResourceLoader.exists("res://assets/textures/pbr/pitch_2k_albedo.png"):
		pitch_mat.albedo_texture = load("res://assets/textures/pbr/pitch_2k_albedo.png")
		pitch_mat.normal_enabled = true
		pitch_mat.normal_texture = load("res://assets/textures/pbr/pitch_2k_normal.png")
		pitch_mat.roughness_texture = load("res://assets/textures/pbr/pitch_2k_roughness.png")
		pitch_mat.ao_enabled = true
		pitch_mat.ao_texture = load("res://assets/textures/pbr/pitch_2k_ao.png")

	# Crisp White Crease Paint
	crease_mat = StandardMaterial3D.new()
	crease_mat.albedo_color = Color(0.98, 0.98, 0.98)
	crease_mat.roughness = 0.35

	# LED Sponsor Boundary Hoardings
	led_mat = StandardMaterial3D.new()
	led_mat.albedo_color = Color(0.08, 0.12, 0.22)
	led_mat.emission_enabled = true
	led_mat.emission = Color(0.12, 0.45, 0.85)
	led_mat.emission_energy_multiplier = 0.6

	# Boundary Rope (White braided polyurethane rope)
	rope_mat = StandardMaterial3D.new()
	rope_mat.albedo_color = Color(0.92, 0.92, 0.92)
	rope_mat.roughness = 0.5

	# Grandstands Concrete & Steel Structure
	stand_mat = StandardMaterial3D.new()
	stand_mat.albedo_color = Color(0.22, 0.25, 0.32)
	stand_mat.roughness = 0.9
	stand_mat.metallic = 0.2

	# Dynamic Multi-Color Crowd
	crowd_mat = StandardMaterial3D.new()
	crowd_mat.albedo_color = Color(0.45, 0.50, 0.65)
	crowd_mat.roughness = 0.95

func _build_mowed_outfield() -> void:
	outfield_root = Node3D.new()
	add_child(outfield_root)

	# Build 8 concentric alternating mowed grass bands (WCC3 stadium lawn effect)
	var num_rings: int = 8
	var ring_step: float = boundary_radius / float(num_rings)

	for r in range(num_rings):
		var inner_rad: float = float(r) * ring_step
		var outer_rad: float = float(r + 1) * ring_step + 0.2
		var is_dark: bool = (r % 2 == 0)

		var ring_mesh := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = outer_rad
		cyl.bottom_radius = outer_rad
		cyl.height = 0.08
		cyl.material = grass_mat_dark if is_dark else grass_mat_light
		ring_mesh.mesh = cyl
		ring_mesh.position.y = -0.04 - float(num_rings - r) * 0.002
		outfield_root.add_child(ring_mesh)

	# Outer apron past boundary
	var apron := MeshInstance3D.new()
	var cyl_a := CylinderMesh.new()
	cyl_a.top_radius = 82.0
	cyl_a.bottom_radius = 82.0
	cyl_a.height = 0.06
	cyl_a.material = grass_mat_dark
	apron.mesh = cyl_a
	apron.position.y = -0.07
	outfield_root.add_child(apron)

func _build_pitch() -> void:
	pitch_mesh = MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(3.05, 0.02, 22.56) # Regulation 10 ft width, 24.67 yards total length
	box.material = pitch_mat
	pitch_mesh.mesh = box
	pitch_mesh.position = Vector3(0, 0.008, 0)
	add_child(pitch_mesh)

func _build_crease_lines() -> void:
	# Popping crease at +9.05m and -9.05m (white line, width 3.66m, thick 0.08m)
	_create_crease_line(Vector3(0, 0.016, 9.05), Vector3(3.66, 0.008, 0.08))
	_create_crease_line(Vector3(0, 0.016, -9.05), Vector3(3.66, 0.008, 0.08))

	# Bowling crease at +10.06m and -10.06m
	_create_crease_line(Vector3(0, 0.016, 10.06), Vector3(2.64, 0.008, 0.05))
	_create_crease_line(Vector3(0, 0.016, -10.06), Vector3(2.64, 0.008, 0.05))

	# Return creases (+/- 1.32m from center)
	_create_crease_line(Vector3(1.32, 0.016, 9.55), Vector3(0.05, 0.008, 1.22))
	_create_crease_line(Vector3(-1.32, 0.016, 9.55), Vector3(0.05, 0.008, 1.22))
	_create_crease_line(Vector3(1.32, 0.016, -9.55), Vector3(0.05, 0.008, 1.22))
	_create_crease_line(Vector3(-1.32, 0.016, -9.55), Vector3(0.05, 0.008, 1.22))

func _create_crease_line(pos: Vector3, size: Vector3) -> void:
	var mi := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	box.material = crease_mat
	mi.mesh = box
	mi.position = pos
	add_child(mi)

func _build_boundary_rope_and_led_boards() -> void:
	boundary_root = Node3D.new()
	add_child(boundary_root)

	# 72 High-Impact LED Sponsor Panels along boundary radius
	var segments: int = 72
	var sponsor_colors: Array[Color] = [
		Color(0.85, 0.15, 0.15), # Red (MRF/Dream11)
		Color(0.15, 0.45, 0.85), # Blue (CEAT/Paytm)
		Color(0.95, 0.75, 0.12), # Gold (TATA IPL)
		Color(0.12, 0.65, 0.35)  # Green (Kookaburra)
	]

	for i in range(segments):
		var angle: float = (float(i) / segments) * TAU
		var pos_led := Vector3(sin(angle) * (boundary_radius + 1.2), 0.45, cos(angle) * (boundary_radius + 1.2))
		
		# LED Board
		var board := MeshInstance3D.new()
		var box_b := BoxMesh.new()
		box_b.size = Vector3(4.8, 0.85, 0.25)
		var b_mat := StandardMaterial3D.new()
		var col: Color = sponsor_colors[i % sponsor_colors.size()]
		b_mat.albedo_color = col
		b_mat.emission_enabled = true
		b_mat.emission = col
		b_mat.emission_energy_multiplier = 0.45
		board.mesh = box_b
		board.material_override = b_mat
		board.position = pos_led
		board.rotation.y = angle + PI * 0.5
		boundary_root.add_child(board)

		# Braided White Boundary Rope in front of board
		var rope_segment := MeshInstance3D.new()
		var cyl_r := CylinderMesh.new()
		cyl_r.top_radius = 0.09
		cyl_r.bottom_radius = 0.09
		cyl_r.height = 4.8
		rope_segment.mesh = cyl_r
		rope_segment.material_override = rope_mat
		rope_segment.position = Vector3(sin(angle) * boundary_radius, 0.08, cos(angle) * boundary_radius)
		rope_segment.rotation = Vector3(0, angle + PI * 0.5, deg_to_rad(90.0))
		boundary_root.add_child(rope_segment)

func _build_sight_screens() -> void:
	sight_screens_root = Node3D.new()
	add_child(sight_screens_root)

	var sight_mat := StandardMaterial3D.new()
	sight_mat.albedo_color = Color(0.96, 0.96, 0.96) # White Sight Screen for Red Ball
	sight_mat.roughness = 0.3

	# Sight screen at Bowler's End (z = -boundary_radius - 2)
	var screen_north := MeshInstance3D.new()
	var box_n := BoxMesh.new()
	box_n.size = Vector3(12.0, 5.5, 0.4)
	screen_north.mesh = box_n
	screen_north.material_override = sight_mat
	screen_north.position = Vector3(0, 2.75, -boundary_radius - 2.5)
	sight_screens_root.add_child(screen_north)

	# Sight screen at Striker's End (z = +boundary_radius + 2)
	var screen_south := MeshInstance3D.new()
	var box_s := BoxMesh.new()
	box_s.size = Vector3(12.0, 5.5, 0.4)
	screen_south.mesh = box_s
	screen_south.material_override = sight_mat
	screen_south.position = Vector3(0, 2.75, boundary_radius + 2.5)
	sight_screens_root.add_child(screen_south)

func _build_grandstands_and_crowd() -> void:
	grandstands_root = Node3D.new()
	add_child(grandstands_root)

	# 3-Tier Colosseum Style Grandstand Bowl
	for tier in range(3):
		var tier_mesh := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		var base_r: float = 78.0 + float(tier) * 9.0
		cyl.top_radius = base_r + 6.0
		cyl.bottom_radius = base_r
		cyl.height = 5.0
		tier_mesh.mesh = cyl
		tier_mesh.material_override = stand_mat
		tier_mesh.position.y = 2.5 + float(tier) * 4.5
		grandstands_root.add_child(tier_mesh)

		# Crowd Seating Deck
		var crowd_deck := MeshInstance3D.new()
		var cyl_c := CylinderMesh.new()
		cyl_c.top_radius = base_r + 5.5
		cyl_c.bottom_radius = base_r + 0.5
		cyl_c.height = 0.4
		crowd_deck.mesh = cyl_c
		
		# Multi-colored crowd texture
		var c_mat := StandardMaterial3D.new()
		c_mat.albedo_color = Color(0.35 + float(tier) * 0.1, 0.42, 0.65)
		c_mat.roughness = 0.95
		crowd_deck.material_override = c_mat
		crowd_deck.position.y = 4.8 + float(tier) * 4.5
		grandstands_root.add_child(crowd_deck)

func _build_floodlight_towers() -> void:
	floodlights_root = Node3D.new()
	add_child(floodlights_root)

	# 4 Monumental Stadium Floodlight Pylons
	var pylon_positions: Array[Vector3] = [
		Vector3(-62, 0, -62),
		Vector3(62, 0, -62),
		Vector3(-62, 0, 62),
		Vector3(62, 0, 62)
	]

	var metal_mat := StandardMaterial3D.new()
	metal_mat.albedo_color = Color(0.32, 0.35, 0.40)
	metal_mat.metallic = 0.85
	metal_mat.roughness = 0.25

	for pos in pylon_positions:
		# Tower Stem
		var pylon := MeshInstance3D.new()
		var cyl := CylinderMesh.new()
		cyl.top_radius = 0.6
		cyl.bottom_radius = 1.4
		cyl.height = 32.0
		pylon.mesh = cyl
		pylon.material_override = metal_mat
		pylon.position = pos + Vector3(0, 16, 0)
		floodlights_root.add_child(pylon)

		# Light Head Fixture
		var head_mesh := MeshInstance3D.new()
		var box_h := BoxMesh.new()
		box_h.size = Vector3(6.0, 3.5, 1.2)
		var lamp_mat := StandardMaterial3D.new()
		lamp_mat.albedo_color = Color(1.0, 1.0, 0.95)
		lamp_mat.emission_enabled = true
		lamp_mat.emission = Color(1.0, 0.98, 0.88)
		lamp_mat.emission_energy_multiplier = 3.5
		head_mesh.mesh = box_h
		head_mesh.material_override = lamp_mat
		head_mesh.position = pos + Vector3(0, 32, 0)
		floodlights_root.add_child(head_mesh)
		head_mesh.look_at(Vector3(0, 1.0, 0), Vector3.UP)

		# Stadium Illumination Spot Light
		var spot := SpotLight3D.new()
		spot.position = pos + Vector3(0, 32, 0)
		spot.spot_range = 140.0
		spot.spot_angle = 45.0
		spot.light_energy = 2.2
		spot.light_color = Color(1.0, 0.96, 0.90)
		spot.shadow_enabled = true
		floodlights_root.add_child(spot)
		spot.look_at(Vector3(0, 0.5, 0), Vector3.UP)

func update_pitch_material(pitch_key: String) -> void:
	if DataManager.pitch_types.has(pitch_key):
		var p: Dictionary = DataManager.pitch_types[pitch_key]
		pitch_mat.albedo_color = p["color"]
