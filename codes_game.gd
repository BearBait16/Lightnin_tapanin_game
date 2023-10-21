extends Node2D 

var space_pressed = false
var space_pressed_duration = 0.0
var morse_input = ""
var start_time = 0.0
var end_time = 0.0
var duration = 0.0
var threshold:float = 200
var codes = {"73": "hugs and kisses","ar": "end of message","as": "stand by","bk": "invite receiving station to transmit","ka": "beginning of message","kn": "end of the transmission","cq": "calling any amateur radio station","72": "best regards","99": "get lost","1": "unreadable","2": "barely readalbe","3": "readable with considerable difficulty","4": "readable with pracctically no difficulty","5": "perfectly readable","yl": "young lady","18": "what's the trouble?","7": "are you ready?"}
var morse_matching = {"0": "-----","1": ".----","2": "..---","3": "...--","4": "....-","5": ".....","6": "-....","7": "--...","8": "---..","9": "----.","a": ".-","b": "-...","c": "-.-.","d": "-..","e": ".","f": "..-.","g": "--.","h": "....","i": "..","j": ".---","k": "-.-","l": ".-..","m": "--","n": "-.","o": "---","p": ".--.","q": "--.-","r": ".-.","s": "...","t": "-","u": "..-","v": "...-","w": ".--","x": "-..-","y": "-.--","z": "--..",".": ".-.-.-",",": "--..--","?": "..--..","!": "-.-.--","-": "-....-","/": "-..-.","@": ".--.-.","(": "-.--.",")": "-.--.-"}
var pause_time = 0
var pressing = true
var failed = false
var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var alph_index = 0
var morse_check = get_morse(codes.keys()[alph_index])
var word = codes.keys()[alph_index]

func _ready():
	print(morse_check)
	$Word.text = word
	#for letter in morse_matching
	
func _process(delta):
	if !pressing:
		pause_time += delta
		if pause_time > (threshold*0.01) and pause_time < threshold*2*.01:
			morse_input += " "
			print(morse_check)
			check_input()
			pause_time = 0
			#morse_input = ""
		elif pause_time > threshold*.01:
			$Right_and_Wrong.text = "Waited to Long"
			$Input.text = ""
			$Sentance_break.text = ""
			reset()

	
func _input(event):
	if Input.is_action_just_pressed('space_down'):
		start_time = Time.get_ticks_msec()
		pressing = true

	elif Input.is_action_just_released('space_down'):
		end_time = Time.get_ticks_msec()
		duration = end_time - start_time
		dot_or_dash()
		duration = 0.0
		pressing = false
		pause_time = 0

func dot_or_dash():
	if duration <= threshold:
		morse_input += "."
	else:
		morse_input += "-"
	$Input.text = morse_input
	$Right_and_Wrong.text = ""

func check_input():
		
		if morse_input.length() < morse_check.length():
			$Sentance_break.text = "check"
			if morse_input != morse_check.substr(0, morse_input.length()):
				$Right_and_Wrong.text = "Not right, try agian"
				reset()
		elif morse_input == morse_check:
			$Right_and_Wrong.text = "Nice! Onto the next one"
			$Input.text = ""
			$Sentance_break.text = ""
			alph_index += 1
			word = codes.keys()[alph_index]
			morse_check = get_morse(word)
			$Word.text = word
			reset()
		else:
			$Right_and_Wrong.text = "Wrong try again"
			$Input.text = ""
			$Sentance_break.text = ""
			reset()

func get_morse(sequence):
	var m_code = ""
	for letter in sequence:
		if (letter in morse_matching.keys()):
			m_code += str(morse_matching[letter])
		m_code += " "
	return m_code

func reset():
	pressing = true
	morse_input = ""
