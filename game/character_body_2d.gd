extends CharacterBody2D

@onready var player = $AnimatedSprite2D  # Cambié de Sprite2D a AnimatedSprite

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_JUMP_Y = -1000
const MIN_JUMP_Y = -300

var direction = 1
var jump_start = 0
var is_charging = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle charged jump
	if Input.is_action_just_pressed("up") and is_on_floor():
		jump_start = Time.get_ticks_msec()/1000.0
		is_charging = true
	if Input.is_action_just_released("up") and is_on_floor() and is_charging:
		velocity.y = get_jump_force((Time.get_ticks_msec()/1000)-jump_start)
		is_charging = false

	# Movimiento lateral
	if Input.is_action_pressed("left"):
		direction = -1
		velocity.x = -SPEED  # Movimiento hacia la izquierda
		player.flip_h = true  # Invertir la animación
		player.animation = "movement"  # Cambiar a la animación de movimiento
	elif Input.is_action_pressed("right"):
		direction = 1
		velocity.x = SPEED  # Movimiento hacia la derecha
		player.flip_h = false  # No invertir la animación
		player.animation = "movement"  # Cambiar a la animación de movimiento
	else:
		velocity.x = 0  # Detenerse cuando no se presiona ninguna tecla de dirección
		player.animation = "idle"  # Cambiar a la animación idle

	# Cambio de animación al saltar
	if not is_on_floor():
		if velocity.y < 0:
			player.animation = "jump0"  # Usar la animación de salto ascendente
		else:
			player.animation = "jump1"  # Usar la animación de caída

	# Aplicar el movimiento
	move_and_slide()

# Finding jump velocity for charged jump
func get_jump_force(time):
	return max(MIN_JUMP_Y + (time * MIN_JUMP_Y), MAX_JUMP_Y)
