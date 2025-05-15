extends Node2D

@onready var time_timer = $Life
var Gtime: float = 0     #is bet time
#used in scoring to gain time 
@onready var Mult : float = 1
#base spin speed with counting how many times its spun around
var speedmult : float = 10
var round : int = 0
var turns : int = 0
#adjusts spin spead based on points needed and bet Time
var BetTimeCoef : float = 1
var NormSpinSpeed = .5
#this controls how fast ur time leaks that ur betting
var LeakCoeff = .93

@onready var handsref= $Clock/Arms # Called when the node enters the scene tree for the first time.
@onready var current_child = 0 
@onready var max_children = handsref.get_child_count() -1
@onready var Hitzones = $Clock/HitHolder
@onready var TimeBetter = $BetWindow/TimeBetter
@onready var BetWindow = $BetWindow
@onready var BetAmountLabel = $BetWindow/TimeBetter/Label3
@onready var UIHandler = $UI
@onready var BetB = $BetButton

func _ready() -> void:
	BetWindow.hide()
	print(time_timer.wait_time)
	$Clock.set_process(false)
	$Clock.connect("sendMult", Scoring)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	#Time Leak Func
	
	
	time_timer.wait_time = float(Gtime)
	if Gtime <= 0:
		#print("game Over")
		$Clock.set_process(false)
	if current_child <= max_children:
		
		$Label.text = str(handsref.get_child(current_child).rotation_degrees)
		$Label2.text = str(Hitzones.get_child(current_child).rotation_degrees)
	$Label3.text = str(time_timer.time_left)
	$Label4.text = "Fuel Time remaining " + str($Clock.Gtime)
		
func Scoring(Mult: Array[float]):
	Gtime = $Clock.Gtime
	print("Scoring: Mult Rceieved", Mult)
	
	time_timer.wait_time
	UIHandler.show()
	
	pass


func _on_time_better_drag_ended(value_changed: bool) -> void:
	
	print(Gtime, " ", time_timer.time_left)
	Gtime = time_timer.time_left * ((TimeBetter.value)/100) #will get the amount of time they want to bet
	print(Gtime, " times ", TimeBetter.value, " is ", time_timer.time_left)
	BetAmountLabel.text = str(Gtime)
	$Clock.Gtime = Gtime


func _on_bet_back_button_pressed() -> void:
	BetWindow.hide()
	
func _on_bet_confirm_button_pressed() -> void:
	BetWindow.hide()
	adjust_timer(Gtime)
	UIHandler.hide() # Replace with function body.
	$Clock.set_process(true)

func adjust_timer(passed: float) -> void:
	time_timer.stop()
	time_timer.wait_time = time_timer.wait_time - passed
	time_timer.start()

func _on_bet_button_pressed() -> void:
	BetWindow.show() # Replace with function body.


func _on_life_timeout() -> void:
	get_tree().paused = true
	#put gameover here
