extends Node

const SHADER = preload("res://graphics/shader/TeamColors.shader")
const FLAG_SHADER = preload("res://graphics/shader/TeamFlag.shader")

var base_color_map := [
	Color("F49AC1"),
	Color("3F0016"),
	Color("55002A"),
	Color("690039"),
	Color("7B0045"),
	Color("8C0051"),
	Color("9E005D"),
	Color("B10069"),
	Color("C30074"),
	Color("D6007F"),
	Color("EC008C"),
	Color("EE3D96"),
	Color("EF5BA1"),
	Color("F172AC"),
	Color("F287B6"),
	Color("F6ADCD"),
	Color("F8C1D9"),
	Color("FAD5E5"),
	Color("FDE9F1")
]

var base_flag_color := []

var team_color_data := {
	"red":[Color("FF0000"),Color("FFFFFF"),Color("000000"),Color("FF0000")],
	"blue":[Color("2E419B"),Color("FFFFFF"),Color("0F0F0F"),Color("0000FF")],
	"green":[Color("62B664"),Color("FFFFFF"),Color("000000"),Color("00FF00")],
	"purple":[Color("93009D"),Color("FFFFFF"),Color("000000"),Color("FF00FF")],
	"black":[Color("5A5A5A"),Color("FFFFFF"),Color("000000"),Color("000000")],
	"white":[Color("E1E1E1"),Color("FFFFFF"),Color("1E1E1E"),Color("FFFFFF")],
	"brown":[Color("945027"),Color("FFFFFF"),Color("000000"),Color("AA4600")],
	"orange":[Color("FF7E00"),Color("FFFFFF"),Color("0F0F0F"),Color("FFAA00")],
	"teal":[Color("30CBC0"),Color("FFFFFF"),Color("000000"),Color("00F0C8")]
}

func _ready() -> void:
	initializeFlagColors()

func generate_team_shader(team_data: Array) -> ShaderMaterial:
	var mat := ShaderMaterial.new()
	mat.shader = SHADER
	var color_map = new_color_map(team_data, base_color_map)
	var i := 1
	for key in color_map:
		mat.set_shader_param("base" + str(i), key)
		mat.set_shader_param("color" + str(i), color_map[key])
		i += 1

	return mat

func generate_flag_shader(team_data: Array) -> ShaderMaterial:
	var mat := ShaderMaterial.new()
	mat.shader = FLAG_SHADER
	var color_map = new_color_map(team_data, base_flag_color)
	var i := 1
	for key in color_map:
		mat.set_shader_param("base" + str(i), key)
		mat.set_shader_param("color" + str(i), color_map[key])
		i += 1
	return mat

func new_color_map(team_data: Array, base_color: Array) -> Dictionary:
	var color_map := {}

	var new_red_avg: float = team_data[0].r
	var new_green_avg: float = team_data[0].g
	var new_blue_avg: float = team_data[0].b

	var new_red_max: float = team_data[1].r
	var new_green_max: float = team_data[1].g
	var new_blue_max: float = team_data[1].b

	var new_red_min: float = team_data[2].r
	var new_green_min: float = team_data[2].g
	var new_blue_min: float = team_data[2].b

	var temp_color: Color = base_color[0]

	var temp_avg = (temp_color.r + temp_color.g + temp_color.b) / 3.0
	for color in base_color:
		var color_avg: float = (color.r + color.g + color.b) / 3.0
		var new_color: Color
		var r: float
		var g: float
		var b: float
		if color_avg <= temp_avg:
			var ratio: float = color_avg / temp_avg

			r = ratio*new_red_avg + (1 - ratio)*new_red_min
			g = ratio*new_green_avg + (1 - ratio)*new_green_min
			b = ratio*new_blue_avg + (1 - ratio)*new_blue_min
		else:
			var ratio: float = (1.0 - color_avg) / (1.0 - temp_avg)

			r = ratio*new_red_avg + (1 - ratio)*new_red_max
			g = ratio*new_green_avg + (1 - ratio)*new_green_max
			b = ratio*new_blue_avg + (1 - ratio)*new_blue_max

		new_color = Color(min(r , 1), min(g , 1), min(b , 1))
		color_map[color] = new_color

	return color_map

func initializeFlagColors() -> void:
	var hex_format := "%X"
	for i in 255:
		var hex_number = hex_format % [(i+1)]
		# Why C8 you ask? Who knows, I hope who ever made this pallete does.
		if (hex_number == "C8"):
			continue
		if hex_number.length() < 2:
			hex_number = "0" + hex_number
		base_flag_color.push_front(Color("00" + hex_number + "00"))
	base_flag_color.push_front(Color("00C800"))