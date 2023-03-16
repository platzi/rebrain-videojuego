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
			var event_dialogue := child as EventDialogue
			var dialogue : Dialogue = get_parent().create_dialogue(event_dialogue.speaker, event_dialogue.dialogues)
			yield(dialogue, "finished")
		elif child is EventHint:
			var event_hint := child as EventHint
			var hint : HintPanel = get_parent().create_hint(event_hint.title, event_hint.hints)
			yield(hint, "closed")
		elif child is EventCustom:
			var event_custom := child as EventCustom
			event_custom.execute()
			yield(event_custom, "finished")
	Globals.disable_inputs = false
	Globals.disable_scripting = false
	emit_signal("finished")
