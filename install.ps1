# ia-orquestrador — instalador Windows (nativo)
# Symlinks/Junctions no Windows exigem Admin ou Modo de Desenvolvedor habilitado.
# Se falhar, o script cai automaticamente para cópia de arquivos.

param()

$ErrorActionPreference = "Stop"
$RepoDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = "$env:USERPROFILE\.claude"

Write-Host "=== ia-orquestrador — instalador Windows ===" -ForegroundColor Cyan
Write-Host ""

function Link-Safe {
    param(
        [string]$Src,
        [string]$Dst
    )

    # Remove symlink/junction existente ou faz backup de item real
    if (Test-Path $Dst) {
        $item = Get-Item $Dst -Force
        $isLink = $item.LinkType -ne $null
        if ($isLink) {
            Remove-Item $Dst -Force
        } else {
            $bak = "${Dst}.bak"
            Rename-Item -Path $Dst -NewName $bak -Force
            Write-Host "  Backup criado: $bak" -ForegroundColor Yellow
        }
    }

    $isDir = Test-Path $Src -PathType Container
    $linked = $false

    try {
        $itemType = if ($isDir) { "Junction" } else { "SymbolicLink" }
        New-Item -ItemType $itemType -Path $Dst -Target $Src -Force | Out-Null
        Write-Host "  Vinculado ($itemType): $Dst" -ForegroundColor Green
        $linked = $true
    } catch {
        # Sem permissão — fallback para cópia
    }

    if (-not $linked) {
        if ($isDir) {
            Copy-Item -Recurse -Force $Src $Dst
        } else {
            Copy-Item -Force $Src $Dst
        }
        Write-Host "  Copiado (sem permissao de symlink): $Dst" -ForegroundColor Yellow
    }
}

Write-Host "[Claude] Vinculando diretorios..."
Link-Safe "$RepoDir\tools\claude\skills"   "$ClaudeDir\skills"
Link-Safe "$RepoDir\tools\claude\agents"   "$ClaudeDir\agents"
Link-Safe "$RepoDir\tools\claude\commands" "$ClaudeDir\commands"

Write-Host "[Claude] Vinculando arquivos..."
Link-Safe "$RepoDir\tools\claude\settings.json" "$ClaudeDir\settings.json"
Link-Safe "$RepoDir\tools\claude\CLAUDE.md"      "$ClaudeDir\CLAUDE.md"

# Futuros adaptadores: tools\gemini\, tools\codex\ etc.
# Adicionar blocos aqui conforme novas ferramentas forem incorporadas

Write-Host ""
Write-Host "Instalacao concluida. Reinicie o Claude para aplicar as mudancas." -ForegroundColor Green
