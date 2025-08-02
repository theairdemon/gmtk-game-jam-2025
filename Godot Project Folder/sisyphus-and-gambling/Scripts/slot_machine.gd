extends Node2D

var slot_list: Array
var slot_dict: Dictionary
var play_slots: bool

var stages_timing = 4
var stages_running_time = [0, 0, 0]
var slots: Array

func _ready() -> void:
	slot_list = ["seven", "star", "dollar", "x", "diamond", "seven", "star", "dollar", "diamond"]
	slot_dict = {
		"seven": 1, 
		"star": 2, 
		"dollar": 3, 
		"x": 0, 
		"diamond": 4
	}
	play_slots = false
	slots = [$LeftSlot, $MiddleSlot, $RightSlot]
	
	$Control/GlobalEarnings.clear()
	$Control/GlobalEarnings.append_text("Total Winnings: $" + str(format_cash(Globals.global_earnings)))
	
	$Control/RemainingPulls.clear()
	$Control/RemainingPulls.append_text("Remaining Pulls: " + str(Globals.step_count))
	

func _process(delta: float) -> void:
	if play_slots:
		if not $LeftSlot.is_playing() and not $MiddleSlot.is_playing() and not $RightSlot.is_playing():
			init_slots()
		for i in range(0, stages_running_time.size()):
			stages_running_time[i] += delta
		
			handle_first_stage(i)
			handle_second_stage(i)
			handle_final_stage(i)
		
			if not $LeftSlot.is_playing() and not $MiddleSlot.is_playing() and not $RightSlot.is_playing():
				calculate_earnings()
				stages_running_time = [0, 0, 0]
				play_slots = false

func calculate_earnings() -> void:
	#slots[0].set_frame_and_progress(0, 0.0)
	#slots[1].set_frame_and_progress(2, 0.0)
	#slots[2].set_frame_and_progress(1, 0.0)
		
	var slot_indices = [slot_list[$LeftSlot.frame], slot_list[$MiddleSlot.frame], slot_list[$RightSlot.frame]]
	var local_slot_dict = {
		"seven": 0, 
		"star": 0, 
		"dollar": 0, 
		"x": 0, 
		"diamond": 0
	}
	
	for slot in slot_indices:
		local_slot_dict[slot] += 1
	
	# NO MONEY LOL
	if local_slot_dict["x"] > 0:
		$Control/Winnings.append_text("You win nothing.")
	
	# 3 matching - very lucky!
	elif local_slot_dict["seven"] == 3:
		$Control/Winnings.append_text("THAT'S INSANE!\n+$250,000")
		Globals.global_earnings += 250000
	elif local_slot_dict["star"] == 3:
		$Control/Winnings.append_text("SUPERSTAR!\n+$110,000")
		Globals.global_earnings += 110000
	elif local_slot_dict["dollar"] == 3:
		$Control/Winnings.append_text("MONEY MONEY!\n+$95,000")
		Globals.global_earnings += 95000
	elif local_slot_dict["diamond"] == 3:
		$Control/Winnings.append_text("SHINE BRIGHT!\n+$175,000")
		Globals.global_earnings += 175000
	
	# 2 matching - pretty good!
	elif local_slot_dict["seven"] == 2:
		$Control/Winnings.append_text("Lucky seven!\n+$10,000")
		Globals.global_earnings += 10000
	elif local_slot_dict["star"] == 2:
		$Control/Winnings.append_text("You're a star to me :)\n+$5,250")
		Globals.global_earnings += 5250
	elif local_slot_dict["dollar"] == 2:
		$Control/Winnings.append_text("Ca$h ca$h baby\n+$6,400")
		Globals.global_earnings += 6400
	elif local_slot_dict["diamond"] == 2:
		$Control/Winnings.append_text("Double diamonds!\n+$8,325")
		Globals.global_earnings += 8325
	
	# 1 working - just dollar and seven for bonus cash
	elif local_slot_dict["seven"] == 1:
		$Control/Winnings.append_text("Not too bad.\n+$50")
		Globals.global_earnings += 50
	elif local_slot_dict["dollar"] == 1:
		$Control/Winnings.append_text("Pity cash :(\n+$7.00")
		Globals.global_earnings += 7
	elif local_slot_dict["diamond"] == 1:
		$Control/Winnings.append_text("Tiny prize for ya\n+$2.00")
		Globals.global_earnings += 2
	else:
		$Control/Winnings.append_text("Better luck next time!")
	
	$Control/GlobalEarnings.clear()
	$Control/GlobalEarnings.append_text("Total Cash: $" + str(format_cash(Globals.global_earnings)))

static func format_cash(number, prefix=''):
	number = int(number)
	var neg = false
	if number < 0:
		number = -number
		neg = true
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]
	if neg: res = '-'+prefix+res
	else: res = prefix+res
	return res

func handle_first_stage(idx: int) -> void:
	if stages_running_time[idx] > stages_timing + idx and stages_running_time[idx] < (stages_timing * 2) + idx:
		slots[idx].play("regular slots", 0.5)

func handle_second_stage(idx: int)  -> void:
	if stages_running_time[idx] > (stages_timing * 2) + idx + idx and stages_running_time[idx] < (stages_timing * 2.5) + idx:
		slots[idx].play("regular slots", 0.25)
	
func handle_final_stage(idx: int)  -> void:
	if stages_running_time[idx] > (stages_timing * 3) + idx:
		var displayed_frame = slots[idx].frame
		slots[idx].stop()
		slots[idx].set_frame_and_progress(displayed_frame, 0.0)

func init_slots() -> void:
	$Control/Winnings.clear()
	
	var indices := range(slot_list.size())
	indices.shuffle()
	
	$LeftSlot.set_frame_and_progress(indices[0], 0.0)
	$LeftSlot.play()
	
	$MiddleSlot.set_frame_and_progress(indices[1], 0.0)
	$MiddleSlot.play()
	
	$RightSlot.set_frame_and_progress(indices[2], 0.0)
	$RightSlot.play()
	
func _on_play_slots_pressed() -> void:
	if Globals.step_count > 0 and not play_slots:
		play_slots = true
		
		Globals.step_count -= 1
		$Control/RemainingPulls.clear()
		$Control/RemainingPulls.append_text("Remaining Pulls: " + str(Globals.step_count))
		
	$SlotMachineSprite.play()
