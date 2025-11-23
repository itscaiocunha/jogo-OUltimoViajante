extends Control

@onready var progress_bar = $ProgressBar
@onready var fundo = $Fundo

var cena_alvo_path: String = ""
var loading_status = 0
var progress = []

var tempo_total := 5.0        # ⏳ Tempo mínimo de exibição
var tempo_passado := 0.0
var carregamento_concluido := false


func _ready():
	if cena_alvo_path == "":
		return

	ResourceLoader.load_threaded_request(cena_alvo_path)


func _process(delta):
	if cena_alvo_path == "":
		return

	# Avança tempo total da tela
	tempo_passado += delta
	var porcentagem_tempo = clamp(tempo_passado / tempo_total, 0.0, 1.0)

	# Atualiza status do carregamento real
	loading_status = ResourceLoader.load_threaded_get_status(cena_alvo_path, progress)

	if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		carregamento_concluido = true

	# DEFINIÇÃO DA BARRA:
	# Enquanto carrega ➜ usa o valor real do carregamento
	# Depois que carregar ➜ barra vai completando com base no tempo total
	var progresso_visual := 0.0

	if not carregamento_concluido:
		# progresso real (0–1)
		progresso_visual = progress[0]
	else:
		# progresso do tempo (faz a barra não travar no fim)
		progresso_visual = porcentagem_tempo

	# Aplica progresso visual na barra
	if progress_bar:
		progress_bar.value = progresso_visual * 100

	# Troca a cena somente quando:
	# - carregamento COMPLETO
	# - e o tempo mínimo (5s) COMPLETO
	if carregamento_concluido and tempo_passado >= tempo_total:
		var nova_cena = ResourceLoader.load_threaded_get(cena_alvo_path)
		get_tree().change_scene_to_packed(nova_cena)

	# Tratamento de erro
	if loading_status == ResourceLoader.THREAD_LOAD_FAILED:
		print("ERRO ao carregar cena:", cena_alvo_path)
	if loading_status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		print("Recurso inválido:", cena_alvo_path)
