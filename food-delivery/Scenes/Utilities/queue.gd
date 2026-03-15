extends Node
class_name Queue

var array : Array

func enqueue(element) -> void:
	array.append(element)
	
func dequeue() -> void:
	array.remove_at(0)
	
func getFront():
	if isEmpty():
		return null
	else:
		return array[0]
	
func getRear():
	if isEmpty():
		return null
	else:
		return array[-1]
	
func isEmpty():
	return array.size() == 0
	
func EmptyQueue():
	array.clear()
