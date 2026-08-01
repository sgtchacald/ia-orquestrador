---
name: prototipo-interface
description: Use when o usuário pede um protótipo, mockup, wireframe ou "tela" de interface durante ou depois de um documento de análise (7GRC ou similar). Gatilhos como "faz o protótipo", "cria a tela", "monta a interface", "mostra como fica", ou pedido da versão draw.io das telas.
---

# Protótipo de Interface (Artifact + draw.io)

## Overview

Protótipo de tela é entregue em **duas fases, nesta ordem**: primeiro um **Artifact HTML navegável** de alta fidelidade (o usuário clica, valida a experiência); só **depois**, e **apenas quando pedido explicitamente**, gera-se o **draw.io** (wireframe estático para a documentação de análise). O draw.io é **regenerado** a partir do protótipo já validado — não é conversão automática do HTML.

## Quando usar

- Usuário pede protótipo/mockup/wireframe de uma ou mais telas.
- Durante/depois de um documento de análise, ao chegar na seção de Protótipos de Interface.
- Pedido isolado: "gera o draw.io dessas telas".

**Quando NÃO usar:** o usuário quer o componente real (Angular/PrimeNG) pra colar no projeto — isso é código de produção, não protótipo.

## Fluxo

```
Pedido de protótipo
      │
      ▼
FASE 1 — Artifact HTML navegável  (sempre)
  ler padrões visuais do projeto → construir → VALIDAR → publicar
      │
      ▼  (só quando o usuário pedir "gera o draw.io")
FASE 2 — draw.io  (documentação)
  regenerar wireframe a partir do protótipo validado
```

## Fase 1 — Artifact HTML navegável

1. **Ler os padrões visuais do projeto ANTES de desenhar.** No 7GRC: `contexto-projeto/7grc-padroes-frontend.md` (cores hex exatas, tipografia, componentes PrimeNG/Nebular, guia de canvas). Nunca extrair cores de imagens PNG do sistema — são imprecisas.
2. **Construir como Artifact self-contained** (HTML/CSS/JS inline, sem CDN — CSP bloqueia). Fidelidade ao design system do projeto: navbar/sidebar/`nb-card`/tabela/badges, tema claro. Para embutir fonte (ex: Rubik), baixar o woff2 e inserir como `@font-face` data-URI via shell (não gastar tokens colando base64).
3. **Preferências do usuário (7GRC):** filtros das telas ficam em **modal via botão "Filtrar"** (não embutidos no thead); ícones de ação em SVG; título do app conforme o usuário definir.
4. **Validar antes de publicar.** Rodar o JS de verdade e conferir erros (arquivos fora do projeto renderizam como snapshot estático — copiar o HTML para dentro da pasta do projeto e testar no navegador). Corrigir bugs antes de entregar o link.
5. **Publicar como Artifact** e mandar o link. Republicar no mesmo arquivo mantém a URL e cria histórico de versões.

## Fase 2 — draw.io (só quando pedido)

- Seguir a **seção 11 do `7grc-padroes-frontend.md`**: canvas 1280×820, `fillColor`/`strokeColor`/`fontColor` por shape, `fontFamily=Helvetica` (aproxima Rubik).
- **Gerar por script** (Python), não à mão — um gerador parametriza o esqueleto (navbar, sidebar, card, tabela) e emite `.drawio` multi-página (uma página por tela + páginas de modais). Validar o XML (`xml.dom.minidom.parseString`) antes de salvar.
- Nomear sem acentos/underscores e informar o caminho salvo.

## Ambiente (Windows do usuário)

Python 3.13 real instalado em `C:\Users\sgtch\AppData\Local\Programs\Python\Python313\python.exe` (com `python-docx`). Se `python`/`py` do PATH falharem (atalho da Microsoft Store), use esse caminho completo. `node` não instalado.

## Erros comuns

| Erro | Correção |
|---|---|
| Gerar draw.io direto, sem o Artifact | Artifact navegável SEMPRE primeiro; draw.io só depois e só se pedido |
| Gerar draw.io proativamente | Só quando o usuário pedir explicitamente |
| Publicar sem testar o JS | Validar rodando no navegador antes do link |
| Extrair cores de PNG do sistema | Usar `7grc-padroes-frontend.md` (hex exatos) |
| Colar base64 de fonte no chat | Embutir via shell (base64 fora do fluxo de tokens) |
