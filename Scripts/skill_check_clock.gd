extends Control

# Example: For arm 1
@onready var arm = $Arm1
@onready var zone = $Sucesszone1

var target_angle = 270         # angle of success zone
var tolerance = 10             # +/- degrees accepted
var arm_speed = 180.0          # degrees/sec
var slowed = false
var full_rotations = 0

func _ready():
	zone.rotation_degrees = target_angle
	zone.visible = true

func _process(delta):
	if not slowed:
		arm.rotation_degrees += arm_speed * delta
		if arm.rotation_degrees >= 360:
			arm.rotation_degrees -= 360
			full_rotations += 1
			if full_rotations >= 1:
				slowed = true
				# Optionally lerp down speed here

	if Input.is_action_just_pressed("skill_check"):
		if is_hit(arm.rotation_degrees, target_angle, tolerance):
			zone.modulate = Color(0, 1, 0, 0.5)  # turn green on hit
			print("SUCCESS!")
		else:
			zone.modulate = Color(1, 0, 0, 0.5)  # red on miss
			print("MISS!")

# --- Angle match logic ---
func is_hit(arm_angle: float, target: float, margin: float) -> bool:
	var delta = abs(fmod((arm_angle - target + 180), 360) - 180)
	return delta <= margin

# --- You can grow/shrink this visually too ---
func scale_zone(scale_factor: float):
	zone.scale = Vector2.ONE * scale_factor
