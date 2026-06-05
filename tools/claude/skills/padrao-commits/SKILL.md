---
name: padrao-commits
description: Use when creating git commits - enforces commit message style with no AI/Claude references
---

# Padrão de Commits

## Regra Principal

Nunca incluir referências ao Claude, IA ou ferramentas de geração em mensagens de commit.

## O que NÃO fazer

```
# ERRADO — não usar
git commit -m "feat: add login
Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"

git commit -m "fix: corrige bug (gerado com Claude)"
git commit -m "refactor: melhora código via IA"
```

## O que fazer

```
# CORRETO — mensagem limpa, focada no que mudou
git commit -m "feat: adiciona autenticação JWT"
git commit -m "fix: corrige validação de formulário de cadastro"
git commit -m "refactor: extrai lógica de paginação para serviço próprio"
```

## Formato de mensagem

```
<tipo>: <descrição curta no imperativo>

[corpo opcional explicando o porquê, não o quê]
```

**Tipos:** `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`

## Aplicação

Esta regra se aplica a todos os commits neste repositório e em qualquer projeto do usuário.
