#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=== ia-orquestrador — instalador Linux/macOS ==="
echo ""

# Garante que os diretórios alvo existem
mkdir -p "$CLAUDE_DIR/skills"

# Cria symlink de forma segura: faz backup se já existir arquivo real
link_safe() {
  local src="$1"
  local dst="$2"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "${dst}.bak"
    echo "  Backup criado: ${dst}.bak"
  fi

  ln -s "$src" "$dst"
  echo "  Vinculado: $dst"
}

# Skills — cada pasta de skill individualmente
echo "[Claude] Instalando skills..."
for skill_dir in "$REPO_DIR/tools/claude/skills"/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name="$(basename "$skill_dir")"
  link_safe "$skill_dir" "$CLAUDE_DIR/skills/$skill_name"
done

# settings.json
echo "[Claude] Instalando settings.json..."
link_safe "$REPO_DIR/tools/claude/settings.json" "$CLAUDE_DIR/settings.json"

# CLAUDE.md global
if [ -f "$REPO_DIR/tools/claude/CLAUDE.md" ]; then
  echo "[Claude] Instalando CLAUDE.md..."
  link_safe "$REPO_DIR/tools/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
fi

# Futuros adaptadores: tools/gemini/, tools/codex/ etc.
# Adicionar blocos aqui conforme novas ferramentas forem incorporadas

echo ""
echo "Instalacao concluida. Reinicie o Claude para aplicar as mudancas."
