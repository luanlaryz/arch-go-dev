# Arch Go Dev Environment

Ambiente portátil para desenvolvimento com **Arch Linux + Go + Neovim**, pensado para ser reproduzido em qualquer PC apenas com **Git + Docker**.

## Objetivo do setup

- Portabilidade: clonar o repositório e subir o mesmo ambiente em outra máquina.
- Persistência versionada: configurações principais (shell, tmux, nvim) ficam no Git.
- Persistência de performance: caches pesados ficam em volumes Docker.

## Estrutura

- `Dockerfile`: imagem base Arch com ferramentas de desenvolvimento.
- `docker-compose.yml`: serviço `dev`, mounts e volumes de cache.
- `Makefile`: comandos para bootstrap, build e acesso ao shell.
- `scripts/bootstrap-dotfiles.sh`: aplica dotfiles versionados de forma idempotente.
- `dotfiles/`: configurações versionadas (`zsh`, `tmux`, `nvim`).
- `workspace/`: diretório de trabalho montado em `/home/dev/workspace`.
- `.env` (local) / `.env.example`: variáveis de UID/GID, SELinux e versões de ferramentas.

## Pré-requisitos

- Docker
- Docker Compose (plugin `docker compose`)
- Make

## Primeiro uso

```bash
make up
make shell
```

O `make up` sempre atualiza `.env` com seu `UID/GID` local e ajusta `SELINUX_LABEL` automaticamente (`:z` quando necessário).

## Comandos Make

- `make env`: gera/atualiza `.env` com valores da máquina local.
- `make build`: build da imagem.
- `make up`: sobe o ambiente em background com build.
- `make down`: para e remove containers/rede.
- `make restart`: reinicia o ambiente.
- `make logs`: acompanha logs do serviço `dev`.
- `make ps`: status dos serviços.
- `make shell`: aplica bootstrap de dotfiles e abre `zsh`.
- `make clean`: remove containers, rede e volumes do projeto.

## Modelo de persistência

- Versionado no Git: `dotfiles/.zshrc`
- Versionado no Git: `dotfiles/.tmux.conf`
- Versionado no Git: `dotfiles/nvim/init.lua`
- Persistido em volume Docker: `go-mod-cache` (`/home/dev/go/pkg/mod`)
- Persistido em volume Docker: `go-build-cache` (`/home/dev/.cache/go-build`)
- Persistido em volume Docker: `nvim-data` (`/home/dev/.local/share/nvim`)

## Atualização de ferramentas Go

As versões podem ser controladas no `.env`:

```bash
GOPLS_VERSION=latest
DLV_VERSION=latest
```

Exemplo com pin:

```bash
GOPLS_VERSION=v0.16.2
DLV_VERSION=v1.23.1
```
