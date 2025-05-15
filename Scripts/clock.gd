extends Area2D

var Gtime: int = 3000     #is bet time
#used in scoring to gain time 
@onready var Mult : float = 1
#base spin speed with counting how many times its spun around
var speedmult : float = 10

var turns : int = 0
#adjusts spin spead based on points needed and bet Time
var BetTimeCoef : float = 1
var NormSpinSpeed = .5
#this controls how fast ur time leaks that ur betting
var LeakCoeff = .96

signal sendMult(Mult: Array[float])
@onready var handsref= $Arms # Called when the node enters the scene tree for the first time.
@onready var current_child = 0 
@onready var max_children = handsref.get_child_count() -1
@onready var Hitzones = $HitHolder
@onready var Inner = $"%Inner"
@onready var Mid = $"%Mid"
@onready var Outer = $"%Outer"
var AllMult: Array[float] = [0,0,0]
@onready var AllHitzones=[Inner,Mid,Outer]

func _ready() -> void:
	for i in Hitzones.get_children():
		i.rotation_degrees = randf_range(0,360)
		print(i.name, " " ,i.rotation_degrees)
	AllMult = [0,0,0]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("UseActive"): 
		current_child +=1
		turns = 0
		if current_child <= max_children:
			print("changing to ", handsref.get_child(current_child).name)
		else: 
			print("no more hands")
			for i in max_children+1:
				print(i, " ", handsref.get_child(i).rotation_degrees, " ",Hitzones.get_child(i).rotation_degrees )
				
				AllMult[i]= handsref.get_child(i).rotation_degrees - Hitzones.get_child(i).rotation_degrees
				
			sendMult.emit(AllMult)
			#Time Leak Func
	
	
	
	if Gtime <= 0:
		print("game Over")
		get_tree().paused = true
	if current_child <= max_children:
		handsref.get_child(current_child).rotation += NormSpinSpeed * BetTimeCoef - (turns*.01)
		Gtime *= pow(LeakCoeff, delta)
		
	#checks to see how many roations
		
		if int(round(handsref.get_child(current_child).rotation_degrees)) >= 360:
			handsref.get_child(current_child).rotation_degrees -= 360
			turns += 1
			#print(Gtime , " ",turns," turn at " ,handsref.rotation_degrees)
