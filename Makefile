SHELL := /bin/bash

COMPOSE := docker compose
SERVICE := dev
ENV_FILE := .env

.PHONY: help env build up down restart logs ps shell clean

help:
	@echo "Comandos disponíveis:"
	@echo "  make env      - Gera/atualiza .env com UID/GID locais e ajuste SELinux"
	@echo "  make build    - Build da imagem do ambiente"
	@echo "  make up       - Sobe o ambiente em background (com build)"
	@echo "  make down     - Para e remove containers/rede"
	@echo "  make restart  - Reinicia o ambiente"
	@echo "  make logs     - Exibe logs do serviço dev"
	@echo "  make ps       - Mostra status dos serviços"
	@echo "  make shell    - Abre shell zsh no container dev (com bootstrap)"
	@echo "  make clean    - Remove containers, rede e volumes do projeto"

env:
	@uid=$$(id -u); \
	gid=$$(id -g); \
	selinux_label=""; \
	gopls_version=$$(grep -E '^GOPLS_VERSION=' $(ENV_FILE) 2>/dev/null | cut -d= -f2-); \
	dlv_version=$$(grep -E '^DLV_VERSION=' $(ENV_FILE) 2>/dev/null | cut -d= -f2-); \
	if [ -z "$$gopls_version" ]; then gopls_version="latest"; fi; \
	if [ -z "$$dlv_version" ]; then dlv_version="latest"; fi; \
	if command -v getenforce >/dev/null 2>&1; then \
		state=$$(getenforce); \
		if [ "$$state" = "Enforcing" ] || [ "$$state" = "Permissive" ]; then \
			selinux_label=":z"; \
		fi; \
	fi; \
	printf "UID=%s\nGID=%s\nSELINUX_LABEL=%s\nGOPLS_VERSION=%s\nDLV_VERSION=%s\n" "$$uid" "$$gid" "$$selinux_label" "$$gopls_version" "$$dlv_version" > $(ENV_FILE); \
	echo "$(ENV_FILE) atualizado (UID=$$uid GID=$$gid SELINUX_LABEL=$$selinux_label GOPLS_VERSION=$$gopls_version DLV_VERSION=$$dlv_version)"

build: env
	$(COMPOSE) build

up: env
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

restart: down up

logs:
	$(COMPOSE) logs -f $(SERVICE)

ps:
	$(COMPOSE) ps

shell:
	$(COMPOSE) exec $(SERVICE) bash -lc "/usr/local/bin/bootstrap-dotfiles && exec zsh -l"

clean:
	$(COMPOSE) down -v --remove-orphans
