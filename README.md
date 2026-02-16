# Arch Go Dev Environment

Ambiente de desenvolvimento com **Arch Linux + Go** usando Docker Compose, com usuário do container alinhado ao `UID/GID` do host.

## Estrutura

- `Dockerfile`: imagem base Arch com ferramentas de desenvolvimento (Go, gopls, dlv, neovim, zsh etc.)
- `docker-compose.yml`: orquestra o serviço `dev`, volumes e diretório de trabalho
- `.env`: define `UID` e `GID` usados no build para evitar problemas de permissão
- `workspace/`: pasta montada em `/home/dev/workspace` dentro do container

## Pré-requisitos

- Docker
- Docker Compose (plugin `docker compose`)
- Make

## Configuração

1. Ajuste `UID` e `GID` em `.env` para seu usuário local:

```bash
id -u
id -g
```

2. Suba o ambiente:

```bash
make up
```

3. Acesse o shell do container:

```bash
make shell
```

## Comandos Make

- `make help`: lista os comandos disponíveis
- `make build`: build da imagem
- `make up`: sobe o ambiente em background (com build)
- `make down`: para e remove containers/rede
- `make restart`: reinicia o ambiente
- `make logs`: acompanha logs do serviço `dev`
- `make ps`: mostra status dos serviços
- `make shell`: abre shell `zsh` no container
- `make clean`: remove containers, rede e volumes do projeto

## Fluxo recomendado

1. `make up`
2. `make shell`
3. Trabalhe no diretório `/home/dev/workspace` (espelhado em `./workspace`)
