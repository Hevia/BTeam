class_name Particle extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func trigger_particle():
	cpu_particles_2d.emitting = true
