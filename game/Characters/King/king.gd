extends CharacterBody2D

# Constantes ajustables
@export var speed = 300.0
@export var jump_velocity = -400.0
@export var gravity = 800.0  # Gravedad personalizada

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Manejar salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Movimiento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		# Suavizar desaceleración
		velocity.x = move_toward(velocity.x, 0, speed * delta)

	# Mover al personaje
	move_and_slide()
