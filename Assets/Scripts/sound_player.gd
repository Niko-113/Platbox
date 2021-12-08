extends AudioStreamPlayer2D

func play_sound(sound):
	set_stream(load(sound))
	connect("finished", self, "goodbye")
	play()
	
func goodbye():
	queue_free()
