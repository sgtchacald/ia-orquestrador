# ia-orquestrador — instalador Windows (nativo)
# Symlinks no Windows exigem Admin ou Modo de Desenvolvedor habilitado.
# Se falhar, o script cai automaticamente para cópia de arquivos.

param()

$ErrorActionPreference = "Stop"
$RepoDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"

Write-Host "=== ia-orquestrador — instalador Windows ===" -ForegroundColor Cyan
Write-Host ""

# Garante que os diretórios alvo existem
New-Item -ItemType Directory -Force -Path "$ClaudeDir\skills" | Out-Null

function Link-Safe {
    param(
        [string]$Src,
        [string]$Dst
    )

    if (Test-Path $Dst) {
        $bakPath = "${Dst}.bak"
        Rename-Item -Path $Dst -NewName $bakPath -Force
        Write-Host "  Backup criado: $bakPath" -ForegroundColor Yellow
    }

    $linked = $false
    try {
        $itemType = if (Test-Path $Src -PathType Container) { "Junction" } else { "SymbolicLink" }
        New-Item -ItemType $itemType -Path $Dst -Target $Src -Force | Out-Null
        Write-Host "  Vinculado ($itemType): $Dst" -ForegroundColor Green
        $linked = $true
    } catch {
        # Sem permissão de symlink — copia como fallback
    }

    if (-not $linked) {
        if (Test-Path $Src -PathType Container) {
            Copy-Item -Recurse -Force $Src $Dst
        } else {
            Copy-Item -Force $Src $Dst
        }
        Write-Host "  Copiado (sem permissao de symlink): $Dst" -ForegroundColor Yellow
    }
}

# Skills
Write-Host "[Claude] Instalando skills..."
Get-ChildItem -Directory "$RepoDir\tools\claude\skills" | ForEach-Object {
    Link-Safe $_.FullName "$ClaudeDir\skills\$($_.Name)"
}

# settings.json
Write-Host "[Claude] Instalando settings.json..."
Link-Safe "$RepoDir\tools\claude\settings.json" "$ClaudeDir\settings.json"

# CLAUDE.md global
$claudeMd = "$RepoDir\tools\claude\CLAUDE.md"
if (Test-Path $claudeMd) {
    Write-Host "[Claude] Instalando CLAUDE.md..."
    Link-Safe $claudeMd "$ClaudeDir\CLAUDE.md"
}

# Futuros adaptadores: tools\gemini\, tools\codex\ etc.
# Adicionar blocos aqui conforme novas ferramentas forem incorporadas

Write-Host ""
Write-Host "Instalacao concluida. Reinicie o Claude para aplicar as mudancas." -ForegroundColor Green
