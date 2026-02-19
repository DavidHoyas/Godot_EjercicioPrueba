extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 100

var sentido = 1  # 1=derecha, -1=izquierda

func _ready() -> void:
	$ani_ene_dyn.play("default")

func _on_ene_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.morir()

func _physics_process(delta: float) -> void:
	# Gravedad solo si no está en suelo
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Detectar suelo adelante
	var hay_suelo_adelante = false
	if has_node("detectorDerecho") and sentido == 1:
		hay_suelo_adelante = $detectorDerecho.is_colliding()
	elif has_node("detectorIzquierdo") and sentido == -1:
		hay_suelo_adelante = $detectorIzquierdo.is_colliding()
	
	# Detectar pared
	var hay_pared_adelante = is_on_wall()
	
	# Cambiar dirección si NO hay suelo O hay pared
	if not hay_suelo_adelante or hay_pared_adelante:
		sentido = -sentido
	
	# Aplicar movimiento
	velocity.x = speed * sentido
	$ani_ene_dyn.flip_h = (sentido == -1)
	
	move_and_slide()
