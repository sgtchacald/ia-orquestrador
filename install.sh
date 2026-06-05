#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== ia-orquestrador — instalador Linux/macOS ==="
echo ""

# Cria symlink de forma segura
# Se já for symlink: substitui. Se for arquivo/diretório real: faz backup.
link_safe() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -d "$dst" ]; then
    mv "$dst" "${dst}.bak"
    echo "  Backup criado: ${dst}.bak"
  elif [ -e "$dst" ]; then
    mv "$dst" "${dst}.bak"
    echo "  Backup criado: ${dst}.bak"
  fi

  ln -s "$src" "$dst"
  echo "  Vinculado: $dst → $src"
}

echo "[Claude] Vinculando diretórios..."
link_safe "$REPO_DIR/tools/claude/skills"   "$CLAUDE_DIR/skills"
link_safe "$REPO_DIR/tools/claude/agents"   "$CLAUDE_DIR/agents"
link_safe "$REPO_DIR/tools/claude/commands" "$CLAUDE_DIR/commands"

echo "[Claude] Vinculando arquivos..."
link_safe "$REPO_DIR/tools/claude/settings.json" "$CLAUDE_DIR/settings.json"
link_safe "$REPO_DIR/tools/claude/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"

# Futuros adaptadores: tools/gemini/, tools/codex/ etc.
# Adicionar blocos aqui conforme novas ferramentas forem incorporadas

echo ""
echo "Instalacao concluida. Reinicie o Claude para aplicar as mudancas."
