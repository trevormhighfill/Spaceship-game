extends Label



func hslider_value_changed(value):
	text = str("Min Distance: ", value)


func max_hslider_value_changed(value):
	$MINHSlider.max_value = value
