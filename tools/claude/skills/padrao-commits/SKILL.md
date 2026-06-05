---
name: padrao-commits
description: Use when creating git commits - enforces Conventional Commits format with no AI/Claude references
---

# Padrão de Commits

## Regra Principal

Seguir o padrão **Conventional Commits** em todos os commits. Nunca incluir referências ao Claude, IA ou ferramentas de geração.

## Formato

```
<tipo>[escopo opcional]: <descrição curta no imperativo>

[corpo opcional — explica o PORQUÊ, não o quê]

[rodapé opcional — BREAKING CHANGE, refs, closes]
```

## Tipos

| Tipo | Quando usar |
|------|-------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Refatoração sem mudança de comportamento |
| `docs` | Documentação |
| `test` | Testes |
| `chore` | Tarefas de build, configs, dependências |
| `style` | Formatação, ponto-e-vírgula, espaços (sem lógica) |
| `perf` | Melhoria de performance |
| `ci` | Mudanças em CI/CD |
| `revert` | Reverte commit anterior |

## Exemplos corretos

```
feat: adiciona autenticação JWT

fix(login): corrige validação de senha com caracteres especiais

refactor(usuario): extrai lógica de paginação para serviço próprio

feat!: altera contrato da API de autenticação

BREAKING CHANGE: o campo `token` foi renomeado para `accessToken`

docs: atualiza instruções de instalação no README

chore: atualiza dependências do Spring Boot para 3.2
```

## O que NÃO fazer

```
# Sem tipo — ERRADO
git commit -m "adiciona login"

# Referência a IA — ERRADO
git commit -m "feat: adiciona login
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

# Descreve o quê, não o porquê no corpo — evitar
git commit -m "feat: adiciona validação
Adicionei um if para checar se o campo está vazio."
```

## Breaking Changes

Sinalizar com `!` após o tipo ou com rodapé `BREAKING CHANGE:`:

```
feat!: remove suporte ao endpoint /api/v1

# ou

feat: migra para API v2

BREAKING CHANGE: endpoint /api/v1 removido, usar /api/v2
```

## Referências a issues

```
fix: corrige timeout na consulta de relatórios

Closes #42
```
