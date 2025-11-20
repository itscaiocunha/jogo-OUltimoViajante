extends Node2D

# Arraste os nós corretos para estas variáveis no Inspetor!
@export var hildegard_inicio: Node2D
@export var medico_centro: Node2D
@export var boticario: Node2D
@export var medico_igreja: Node2D
@export var hildegard_final: Node2D

func _ready():
	# Pega o status atual da quest
	var status = GameManager.quest_status
	
	print("Vila carregada com status: ", status)
	
	# Esconde todos os NPCs de quest por padrão
	hildegard_inicio.hide()
	medico_centro.hide()
	boticario.hide()
	medico_igreja.hide()
	hildegard_final.hide()
	
	# Agora, mostra apenas o correto
	if status == "":
		# Início do jogo (depois da Cena 2)
		hildegard_inicio.show()
		
	elif status == "encontrar_medico":
		# Falou com Hildegard, precisa achar o médico
		hildegard_inicio.show() # Deixa ela visível
		medico_centro.show()    # Mostra o médico no centro
		
	elif status == "encontrar_boticario":
		# Falou com o Médico, precisa achar o boticário
		hildegard_inicio.show()
		medico_centro.show()
		boticario.show()
		
	elif status == "remedio_pronto":
		# Fez a poção! O MÉDICO MUDA DE LUGAR.
		hildegard_inicio.show()
		boticario.show()
		# medico_centro.hide() # Já está escondido
		medico_igreja.show()   # Mostra o médico na igreja
		
	elif status == "eliminar_ratos":
		# Falou com o médico na igreja, precisa achar Hildegard
		# (O médico da igreja some após a Cena 6)
		hildegard_final.show() # Mostra a Hildegard "Final"
		
	elif status == "ratos_eliminados":
		# Terminou a task dos ratos, precisa falar com Hildegard
		hildegard_final.show()
