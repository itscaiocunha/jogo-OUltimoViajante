# 🕯️ O Último Viajante

**O Último Viajante** é um jogo narrativo de aventura e puzzle 2D desenvolvido na **Godot Engine 4.3**.  
O jogador controla um estudante universitário moderno transportado para o ano de **1347**, durante a **Peste Negra**, e deve usar seu conhecimento para ajudar os habitantes de uma vila medieval.

---

## 📋 Sobre o Projeto

Este jogo foi desenvolvido como parte do **Projeto Integrado** do curso de _Ciência da Computação_ da **UNIFEOB**.

Leia o GDD completo em [GDD - Completo](https://docs.google.com/document/d/1Ff3aHtOP-XPoLohz-P69YtS2W0p3Cvug9fbZSnMqxFU/edit?usp=sharing)

### 🎮 Mecânicas Principais

- **Exploração:** Navegação point-and-click em cenário isométrico.
- **Diálogos:** Sistema de narrativa interativa.
- **Minijogos:**
  - **Click Point (Hidden Object):** Encontrar itens e limpar o cenário.
  - **Alquimia (Drag & Drop):** Preparar poções seguindo receitas.

---

## 🛠️ Tecnologias Utilizadas

- **Motor de Jogo:** Godot Engine 4.3
- **Linguagem:** GDScript
- **Arte:** Pixel Art

---

## 🚀 Instalação e Execução

### 🔧 Pré-requisitos

Baixe e instale a **Godot Engine 4.3** (Standard ou .NET — ambas funcionam para GDScript):  
👉 https://godotengine.org/download

### 📥 Passos

**1. Clone ou Baixe este repositório:**

```bash
git clone https://github.com/seu-usuario/o-ultimo-viajante.git
```

(Ou baixe o ZIP e extraia).

**2. Importe no Godot:**

- Abra a Godot Engine.
- Clique em Import (Importar).
  \*Navegue até a pasta ultimoviajante (onde está o arquivo project.godot).
- Clique em Open (Abrir).
- Clique em Import & Edit (Importar e Editar).

**3. Execute o Jogo:**

Com o projeto aberto, pressione F5 no teclado (ou clique no botão de Play no canto superior direito) para rodar a cena principal (MenuPrincipal.tscn).

## ⚙️ Configuração Avançada (DSL)

Este projeto utiliza um sistema de DSL (Domain Specific Language) simples via arquivos de texto para configurar a dificuldade dos minijogos sem alterar o código.

Para alterar a dificuldade da fase da Hildegard (Click Point):

1. Vá até a pasta: res://configs/ (no FileSystem do Godot ou no explorador de arquivos).
2. Abra o arquivo: nivel_hildegard.txt.
3. Altere o valor de qtde_lixos:

```bash
qtde_lixos = 7 # Dificuldade Normal
qtde_lixos = 3 # Dificuldade Fácil
```

4. Salve o arquivo e rode o jogo novamente. O objetivo da fase será atualizado automaticamente.

## 🎮 Controles

Mouse (Botão Esquerdo): Interagir com tudo — andar, falar, arrastar itens, clicar em botões.

## 👥 Créditos

### 🎮 Desenvolvimento e Direção

- Caio Grilo da Cunha (RA 22000246)

### ✍️ Roteiro

- Haryel Araújo de Oliveira Caliari (RA 22001470)

### 🎨 Design Visual

- Gian Carlos de Freitas Moroni (RA 22000843)
- Jackeline Ayumi Kanekiyo (RA 22001803)

### 🔊 Design Sonoro

- Jackeline Ayumi Kanekiyo (RA 22001803)

### 💰 Financiamento

- UNIFEOB

## 🙌 Obrigado por jogar!
