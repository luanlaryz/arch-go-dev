SHELL := /bin/bash

COMPOSE := docker compose
SERVICE := dev

.PHONY: help build up down restart logs ps shell clean

help:
	@echo "Comandos disponíveis:"
	@echo "  make build    - Build da imagem do ambiente"
	@echo "  make up       - Sobe o ambiente em background (com build)"
	@echo "  make down     - Para e remove containers/rede"
	@echo "  make restart  - Reinicia o ambiente"
	@echo "  make logs     - Exibe logs do serviço dev"
	@echo "  make ps       - Mostra status dos serviços"
	@echo "  make shell    - Abre shell zsh no container dev"
	@echo "  make clean    - Remove containers, rede e volumes do projeto"

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f $(SERVICE)

ps:
	$(COMPOSE) ps

shell:
	$(COMPOSE) exec $(SERVICE) zsh

clean:
	$(COMPOSE) down -v --remove-orphans
