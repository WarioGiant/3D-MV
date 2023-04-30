@tool
extends StaticBody3D

@export var offset := 0.0
@export var time_on := 5.0
@export var time_off := 5.0
var spewing := false
var time := 0.0

func _ready() -> void:
	time = offset

func switch():
	time = 0
	spewing = !spewing
	$GPUParticles3D.emitting = spewing

func _physics_process(delta: float) -> void:
	time += delta
	if spewing and (time > time_on):
		switch()
	elif not spewing and (time > time_off):
		switch()
