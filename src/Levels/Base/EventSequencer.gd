extends Node


signal finished


func execute() -> void:
	if get_child_count() == 0:
		emit_signal("finished")
		return
	Globals.disable_inputs = true
	Globals.disable_scripting = true
	for child in get_children():
		if child is EventDialogue:
			var eventDialogue := child as EventDialogue
			var dialogue : Dialogue = get_parent().create_dialogue(eventDialogue.speaker, eventDialogue.dialogues)
			yield(dialogue, "finished")
		elif child is EventHint:
			var eventHint := child as EventHint
			var hint : HintPanel = get_parent().create_hint(eventHint.title, eventHint.hints)
			yield(hint, "closed")
	Globals.disable_inputs = false
	Globals.disable_scripting = false
	emit_signal("finished")
