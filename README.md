# ia-orquestrador

Repositório central de configurações de IA. Funciona como fonte da verdade para skills, agentes e configurações — basta clonar e rodar o instalador.

## Como instalar

**Linux / macOS**
```bash
git clone https://github.com/SEU_USUARIO/ia-orquestrador.git
cd ia-orquestrador
chmod +x install.sh
./install.sh
```

**Windows (nativo)**
```powershell
git clone https://github.com/SEU_USUARIO/ia-orquestrador.git
cd ia-orquestrador
.\install.ps1
```
> No Windows, symlinks exigem Admin ou Modo de Desenvolvedor habilitado. Se não tiver, o instalador copia os arquivos automaticamente (sem sincronização em tempo real).

## Estrutura

```
ia-orquestrador/
├── shared/                  # conteúdo neutro, reutilizável entre IAs
│   ├── instructions/        # regras gerais de comportamento
│   ├── prompts/             # prompts reaproveitáveis
│   └── knowledge/           # contexto sobre projetos e preferências
├── tools/
│   └── claude/              # adaptador Claude Code
│       ├── CLAUDE.md        # instruções globais
│       ├── skills/          # skills customizadas
│       ├── agents/          # subagentes (futuro)
│       ├── commands/        # comandos customizados (futuro)
│       └── settings.json    # plugins habilitados e tema
├── install.sh               # instalador Linux/macOS
├── install.ps1              # instalador Windows
└── .gitignore
```

## Plugins instalados (Claude)

| Plugin | Função |
|--------|--------|
| `superpowers` | Workflows de desenvolvimento (TDD, debugging, code review) |
| `frontend-design` | Design de interfaces frontend |
| `context7` | Documentação atualizada de bibliotecas via MCP |
| `code-review` | Revisão de código e PRs |

> Os plugins precisam ser instalados manualmente via `/install` dentro do Claude Code. O `settings.json` apenas os habilita.

## Adicionar nova IA

1. Crie `tools/<nome-da-ia>/` com os arquivos no formato da ferramenta
2. Adicione o bloco de instalação correspondente em `install.sh` e `install.ps1`
3. Conteúdo reutilizável vai em `shared/` e é referenciado pelo adaptador

## O que NÃO vai no repositório

- API keys, tokens, credenciais
- Histórico de conversas, cache, sessões
- Arquivos internos gerados pelo Claude
