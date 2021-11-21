extends Node2D

var platforms
var tokens

func _ready():
	tokens = 4
	platforms = self.get_children()
	
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	while tokens >= 4:
		for i in 4:
			var valid = rng.randi_range(0, 1)
			if (valid == 1):
				check_validity(i)
			
		
	
func check_validity(plat_no):
	if (plat_no == 0 or plat_no == 5) and tokens > 1:
		enable_platform(0)
		enable_platform(5)
	elif (plat_no == 1 or plat_no == 4) and platforms[0].visible and tokens > 1:
		enable_platform(1)
		enable_platform(4)
	elif (plat_no == 3) and (platforms[0].visible or platforms[2].visible) and tokens > 0:
		enable_platform(plat_no)
	elif (plat_no == 2) and tokens > 0:
		enable_platform(plat_no)
		
func enable_platform(plat_no):
	tokens -= 1
	platforms[plat_no].visible = true
	platforms[plat_no].get_node("CollisionShape2D").set_deferred("disabled", false)
