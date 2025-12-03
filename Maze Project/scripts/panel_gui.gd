extends Control

signal Opened
signal Closed

var isOpen

func open():
	visible = true
	isOpen = true
	Opened.emit()
	
func close():
	visible = false
	isOpen = false
	Closed.emit()
