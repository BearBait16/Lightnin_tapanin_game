extends Node2D

var space_pressed = false
var space_pressed_duration = 0.0
var morse_input = ""
var start_time = 0.0
var end_time = 0.0
var duration = 0.0
var threshold:float = 200
var words = ["able","acid","acre","aged","aide","aims","airy","ajar","akin","alea","ally","also","amok","anon","apex","arch","aria","arid","army","aunt","aura","avid","back","bale","bang","bark","base","bats","beak","beef","bell","belt","best","bide","bike","bird","bite","bits","blip","boil","bolt","bone","boon","boot","born","boss","both","bump","burn","bush","cane","cape","cars","case","cave","chew","chin","city","clip","clue","club","code","cool","cord","core","corn","cube","cult","curb","cure","curl","cute","dark","date","dash","deal","dear","debt","deep","deer","desk","dice","dirt","dive","dome","door","dose","doty","dune","dusk","dust","duty","earl","easy","echo","edit","eggs","elms","emus","ends","epic","eros","even","ever","evil","eyes","fact","fade","fair","fall","fame","farm","fast","fats","fear","feet","fell","felt","fest","film","find","firm","fish","fist","five","flag","flat","flee","flip","flow","fold","food","fool","foot","ford","fore","fork","form","fort","free","fuel","full","fund","fury","fuse","gain","game","gang","gate","gear","gift","girl","give","glad","golf","gone","good","gray","grew","grip","grit","grow","gush","hair","half","halt","hand","hard","hare","harm","hate","have","hawk","head","heal","heat","held","help","here","hero","hide","high","hill","hint","hiss","hold","home","hope","host","hour","huge","hunt","hurt","idea","inca","inch","into","iron","itch","jade","jail","jake","jars","java","jaws","jazz","jets","jive","jobs","join","joke","jump","jury","just","kale","keen","keep","kelp","kids","kill","king","kiss","kite","knee","knot","lark","late","leak","lean","lend","less","lift","like","line","list","live","load","loft","long","look","lost","love","luck","luna","lush","lust","lute","lyle","mage","mail","make","male","many","mars","mask","mate","maze","meal","mean","menu","mess","mind","mint","mole","moon","most","move","much","must","name","near","neat","need","nest","news","next","nice","night","nine","noct","noel","none","noon","nose","note","nuke","nuts","oars","oats","odd","ogre","oils","oink","okra","omen","open","opus","oral","oval","over","pail","pain","pale","park","part","pass","path","peak","peas","peek","pest","pets","pick","pigs","pine","pink","pint","pipe","pita","play","plop","plug","pong","pool","poor","port","post","pull","pump","pure","purr","push","quit","quiz","race","rage","rain","rank","rare","rate","read","real","reap","rear","red","reed","reef","rest","ride","ring","risk","road","rock","role","roll","roof","rose","rule","safe","sage","sail","sale","salt","same","sand","save","sawn","sayy","seam","seas","seat","self","send","sets","shag","sham","shed","shoe","shot","show","shut","side","sign","sink","sire","size","skin","slam","slat","slow","slug","smog","snap","snow","soar","sock","soda","sole","some","song","soon","soul","spot","star","stay","step","stir","such","sulk","sure","take","tale","talk","tall","tame","tape","tare","tars","tart","task","taut","team","tear","tend","test","text","than","that","thee","them","then","they","thin","this","thud","time","tire","toes","tone","tool","toot","torn","tory","tour","town","trap","tree","trek","trio","trip","trot","true","turn","twin","type","ugly","undo","unit","uran","urch","vale","vamp","vary","vase","vein","verb","very","vibe","vine","vise","viva","void","vote","wail","wait","wake","wane","want","ware","warm","wave","weak","wear","weed","week","weep","weir","welt","wend","were","west","wet","what","when","whip","whom","wife","wild","will","wind","wine","wing","wink","wire","wise","wish","with","wits","word","work","worm","worn","wove","wrap","xray","yawn","year","yell","yoga","yolk","your","yurt","zany","zero","zest","zinc","zone","zoom"]
var morse_matching = {"0": "-----","1": ".----","2": "..---","3": "...--","4": "....-","5": ".....","6": "-....","7": "--...","8": "---..","9": "----.","a": ".-","b": "-...","c": "-.-.","d": "-..","e": ".","f": "..-.","g": "--.","h": "....","i": "..","j": ".---","k": "-.-","l": ".-..","m": "--","n": "-.","o": "---","p": ".--.","q": "--.-","r": ".-.","s": "...","t": "-","u": "..-","v": "...-","w": ".--","x": "-..-","y": "-.--","z": "--..",".": ".-.-.-",",": "--..--","?": "..--..","!": "-.-.--","-": "-....-","/": "-..-.","@": ".--.-.","(": "-.--.",")": "-.--.-"}
var pause_time = 0
var pressing = true
var failed = false
var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
var alph_index = 0
var word = words.pick_random()
var morse_check = get_morse(word)
var end_counter = 0
var end = len(words)

func _ready():
	print(morse_check)
	print(word)
	$Output_word.text = word
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
			$Output_word.text = "Waited to Long"
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
	$Break_space.text = ""

func check_input():
		
		if morse_input.length() < morse_check.length():
			$Break_space.text = "Continue"
			if morse_input !=morse_check.substr(0,morse_input.length()):
				$Right_and_Wrong.text = "Not right, try agian"
				$Input.text = ""
				$Break_space.text = ""
				reset()
		elif morse_input == morse_check:
			$Right_and_Wrong.text = "Nice! Onto the next one"
			end_counter += 1
			if end_counter == end:
				$Control/Output.text = "Congratulations!"
				get_tree().create_timer(5)
				change_scene()
				return
			$Input.text = ""
			$Break_space.text = ""
			word = words.pick_random()
			morse_check = get_morse(word)
			reset()
		else:
			$Right_and_Wrong.text = "Wrong try again"
			$Input.text = ""
			$Break_space.text = ""
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

func change_scene():
	get_tree().change_scene_to_file("res://main.tscn")
