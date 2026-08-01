#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
GEMINI_DIR="$HOME/.gemini/antigravity"

echo "=== ia-orquestrador — instalador Linux/macOS ==="
echo ""

mkdir -p "$CLAUDE_DIR"
mkdir -p "$GEMINI_DIR"

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

echo ""
echo "[Gemini / Antigravity] Vinculando diretórios..."
link_safe "$REPO_DIR/tools/gemini/skills"   "$GEMINI_DIR/skills"
link_safe "$REPO_DIR/tools/gemini/agents"   "$GEMINI_DIR/agents"
link_safe "$REPO_DIR/tools/gemini/commands" "$GEMINI_DIR/commands"

echo "[Gemini / Antigravity] Vinculando arquivos..."
link_safe "$REPO_DIR/tools/gemini/GEMINI.md" "$GEMINI_DIR/GEMINI.md"

echo ""
echo "[Claude] Instalando plugins..."
if command -v claude >/dev/null 2>&1; then
  claude plugin install frontend-design@claude-plugins-official
  claude plugin install superpowers@claude-plugins-official
  claude plugin install context7@claude-plugins-official
  claude plugin install code-review@claude-plugins-official
else
  echo "  AVISO: comando 'claude' nao encontrado no PATH (comum no app Desktop, que nao"
  echo "  expoe um CLI de sistema). Abra o Claude e rode dentro do chat:"
  echo "    /plugin install frontend-design@claude-plugins-official"
  echo "    /plugin install superpowers@claude-plugins-official"
  echo "    /plugin install context7@claude-plugins-official"
  echo "    /plugin install code-review@claude-plugins-official"
fi

echo ""
echo "Instalacao concluida. Reinicie o Claude e/ou o Antigravity para aplicar as mudancas."
