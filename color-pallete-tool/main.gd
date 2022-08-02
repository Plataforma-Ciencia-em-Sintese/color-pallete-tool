tool
#class_name Name #, res://class_name_icon.svg
extends Control


#  [DOCSTRING]


#  [SIGNALS]


#  [ENUMS]


#  [CONSTANTS]
const PRIMARY: String = "#9A63B8"
const SECONDARY: String = "#B8D54D"


#  [EXPORTED_VARIABLES]
export var primary: Color = Color(PRIMARY) \
		setget set_primary, get_primary
export var secondary: Color = Color(SECONDARY) \
		setget set_secondary, get_secondary


#  [PUBLIC_VARIABLES]


#  [PRIVATE_VARIABLES]


#  [ONREADY_VARIABLES]
onready var change_primary_colors: Button = $ChangeColorPrimary
onready var change_secondary_colors: Button = $ChangeColorSecondary


#  [OPTIONAL_BUILT-IN_VIRTUAL_METHOD]
#func _init() -> void:
#	pass


#  [BUILT-IN_VURTUAL_METHOD]
#func _ready() -> void:
#	pass


#  [REMAINIG_BUILT-IN_VIRTUAL_METHODS]
#func _process(_delta: float) -> void:
#	pass


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.pressed:
		if event.as_text() in ["Escape", "Enter", "Kp Enter"]:
			var panel_picker_primary: PanelContainer = $PanelContainerPrimary
			var panel_picker_secondary: PanelContainer = $PanelContainerSecondary
			panel_picker_primary.visible = false
			panel_picker_secondary.visible = false


#  [PUBLIC_METHODS]
func set_primary(new_value: Color) -> void:
	primary = new_value
	change_primary()


func get_primary() -> Color:
	return primary


func set_secondary(new_value: Color) -> void:
	secondary = new_value
	change_secondary()


func get_secondary() -> Color:
	return secondary


func hsv_to_hsl(h: float, s: float, v: float):
	var l = v * (1 - s/2)
	s = 0 if l in [0, 1] else (v - l)/min(l, 1-l)
	print("h: ", round(h*360.0), " s: ", round(s*100.0), " l: ", round(l*100.0))
	print("h: ", h, " s: ", s, " l: ", l)


func hsl_to_hsv(h: float, s: float, l: float):
	var v = l + s * min(l, 1-l)
	s = 0 if v == 0 else 2*(1 - l/v)
	print("h: ", round(h*360.0), " s: ", round(s*100.0), " v: ", round(v*100.0))
	print("h: ", h, " s: ", s, " v: ", v)


func hsl_to_color(new_h: float, new_s: int, new_l: int) -> Color:
	var h: float = new_h
	var s: float = new_s/100.0
	var l: float = new_l/100.0
	
	# make HSV/HSB
	var v = l + s * min(l, 1-l)
	s = 0 if v == 0 else 2*(1 - l/v)
	
	print("h: ", h,  " s: ", s, " l: ", l)
	print("h: ", round(h*360.0), " s: ", round(s*100.0), " l: ", round(l*100.0))
	
	return Color.from_hsv(h, s, v, 1.0)


func hsl_color_luminosity(color: Color, luminosity: int) -> Color:
	var s: float = color.s
	var v: float = color.v
	
	# make h(s)l
	var l = v * (1 - s/2)
	s = 0 if l in [0, 1] else (v - l)/min(l, 1-l)
	
	# return hsv
	l = luminosity / 100.0
	v = l + s * min(l, 1-l)
	s = 0 if v == 0 else 2*(1 - l/v)
	
	return Color.from_hsv(color.h, s, v)


#  [PRIVATE_METHODS]
func change_primary() -> void:
	var primary_colors: HBoxContainer = $"MarginContainer/Palettes/Primary"
	#var primary_labels: Node = $"PrimaryLabels"
	
#	if primary_colors != null:
#		 # HueSaturation(Luminosity) PL3, PL2, PL1, PB, PD1, PD2, PD3
#		var luminosities: Array = [90, 80, 70, 55, 40, 30, 20]
#		var saturation: int = 37
#		for child in primary_colors.get_children():
#			if child is ColorRect:
#
#				# (H)SL = immutable saturation an luminosity
#				if child.get_index() == 3:
#					child.color = get_primary()
#				else:
#					child.color = hsl_to_color(get_primary().h, saturation, luminosities[child.get_index()])
#
#				# (HS)L = immutable luminosity
#				#child.color = hsl_color_luminosity(get_primary(), luminosities[child.get_index()])
#
#				child.get_node("RichTextLabel").text = "#" + str(child.color.to_html(false)).to_upper() \
#						+ "\n\n" + "H: " + str(round(child.color.h*360.0)) \
#						+ "\n\n" + "S: " + str(round(child.color.s*100.0)) \
#						+ "\n\n" + "V/B: " + str(round(child.color.v*100.0))
	
	if primary_colors != null:
		# HueSaturation(Luminosity) PL3, PL2, PL1, PB, PD1, PD2, PD3
		var luminosities: Array = [
			get_primary().lightened(0.75), 
			get_primary().lightened(0.50), 
			get_primary().lightened(0.25), 
			get_primary(),
			get_primary().darkened(0.25),
			get_primary().darkened(0.50),
			get_primary().darkened(0.75)
		]
		for child in primary_colors.get_children():
			if child is ColorRect:
				child.color = luminosities[child.get_index()]
				child.get_node("RichTextLabel").text = "#" + str(child.color.to_html(false)).to_upper() \
						+ "\n\n" + "H: " + str(round(child.color.h*360.0)) \
						+ "\n\n" + "S: " + str(round(child.color.s*100.0)) \
						+ "\n\n" + "V/B: " + str(round(child.color.v*100.0))


func change_secondary() -> void:
	var secondary_colors: HBoxContainer = $"MarginContainer/Palettes/Secondary"
	#var secondary_labels: Node = $"SecondaryLabels"
	
	if secondary_colors != null:
		# HueSaturation(Luminosity) PL3, PL2, PL1, PB, PD1, PD2, PD3
		var luminosities: Array = [
			get_secondary().lightened(0.75), 
			get_secondary().lightened(0.50), 
			get_secondary().lightened(0.25), 
			get_secondary(),
			get_secondary().darkened(0.25),
			get_secondary().darkened(0.50),
			get_secondary().darkened(0.75)
		]
		for child in secondary_colors.get_children():
			if child is ColorRect:
				child.color = luminosities[child.get_index()]
				child.get_node("RichTextLabel").text = "#" + str(child.color.to_html(false)).to_upper() \
						+ "\n\n" + "H: " + str(round(child.color.h*360.0)) \
						+ "\n\n" + "S: " + str(round(child.color.s*100.0)) \
						+ "\n\n" + "V/B: " + str(round(child.color.v*100.0))


#  [SIGNAL_METHODS]
func _on_ChangeColorPrimary_pressed() -> void:
	var panel_picker1: PanelContainer = $PanelContainerPrimary
	var panel_picker2: PanelContainer = $PanelContainerSecondary
	panel_picker2.visible = false
	panel_picker1.visible = true
	panel_picker1.get_node("ColorPicker").color = get_primary()
	panel_picker1.get_node("ColorPicker").add_preset(Color(PRIMARY))


func _on_ChangeColorSecondary_pressed() -> void:
	var panel_picker2: PanelContainer = $PanelContainerSecondary
	var panel_picker1: PanelContainer = $PanelContainerPrimary
	panel_picker1.visible = false
	panel_picker2.visible = true
	panel_picker2.get_node("ColorPicker").color = get_secondary()
	panel_picker2.get_node("ColorPicker").add_preset(Color(SECONDARY))


func _on_PrimaryColorPicker_color_changed(color: Color) -> void:
	set_primary(color)


func _on_SecondaryColorPicker_color_changed(color: Color) -> void:
	set_secondary(color)
