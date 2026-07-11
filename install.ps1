#Requires -Version 5.1
<#
    ia-orquestrador - instalador Windows (PowerShell)
    Equivalente ao install.sh (Linux/macOS)
#>

$ErrorActionPreference = "Stop"

$RepoDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $HOME ".claude"

Write-Host "=== ia-orquestrador - instalador Windows ===" -ForegroundColor Cyan
Write-Host ""

# Verifica se esta rodando como Administrador (necessario para symlinks,
# a menos que o Developer Mode esteja ativado)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "AVISO: Voce nao esta rodando como Administrador." -ForegroundColor Yellow
    Write-Host "Criar symlinks pode falhar, a menos que o 'Developer Mode' esteja habilitado" -ForegroundColor Yellow
    Write-Host "(Configuracoes > Privacidade e seguranca > Para desenvolvedores)." -ForegroundColor Yellow
    Write-Host ""
}

if (-not (Test-Path $ClaudeDir)) {
    New-Item -ItemType Directory -Path $ClaudeDir -Force | Out-Null
}

# Cria symlink de forma segura.
# Se ja for symlink: substitui. Se for arquivo/diretorio real: faz backup.
function Link-Safe {
    param(
        [string]$Src,
        [string]$Dst
    )

    if (Test-Path $Dst) {
        $item = Get-Item $Dst -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Remove-Item $Dst -Force -Recurse
        }
        else {
            $backup = "$Dst.bak"
            Move-Item -Path $Dst -Destination $backup -Force
            Write-Host "  Backup criado: $backup"
        }
    }

    $target = Get-Item $Src -Force
    if ($target.PSIsContainer) {
        New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
    }
    else {
        New-Item -ItemType SymbolicLink -Path $Dst -Target $Src | Out-Null
    }
    Write-Host "  Vinculado: $Dst -> $Src"
}

Write-Host "[Claude] Vinculando diretorios..."
Link-Safe -Src (Join-Path $RepoDir "tools\claude\skills")   -Dst (Join-Path $ClaudeDir "skills")
Link-Safe -Src (Join-Path $RepoDir "tools\claude\agents")   -Dst (Join-Path $ClaudeDir "agents")
Link-Safe -Src (Join-Path $RepoDir "tools\claude\commands") -Dst (Join-Path $ClaudeDir "commands")

Write-Host "[Claude] Vinculando arquivos..."
Link-Safe -Src (Join-Path $RepoDir "tools\claude\settings.json") -Dst (Join-Path $ClaudeDir "settings.json")
Link-Safe -Src (Join-Path $RepoDir "tools\claude\CLAUDE.md")     -Dst (Join-Path $ClaudeDir "CLAUDE.md")

# Futuros adaptadores: tools\gemini\, tools\codex\ etc.
# Adicionar blocos aqui conforme novas ferramentas forem incorporadas

Write-Host ""
Write-Host "[Claude] Verificando CLI..."

# O instalador nativo do Claude Code (irm https://claude.ai/install.ps1 | iex)
# coloca o binario em %USERPROFILE%\.local\bin mas nao garante que esse
# diretorio esteja no PATH da sessao atual (nem sempre persiste no PATH
# de usuario). Corrige os dois casos aqui para nao depender de reabrir o terminal.
$claudeLocalBin = Join-Path $HOME ".local\bin"
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    if (Test-Path (Join-Path $claudeLocalBin "claude.exe")) {
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$claudeLocalBin*") {
            [Environment]::SetEnvironmentVariable("Path", "$userPath;$claudeLocalBin", "User")
            Write-Host "  PATH de usuario atualizado com $claudeLocalBin"
        }
        if ($env:Path -notlike "*$claudeLocalBin*") {
            $env:Path = "$env:Path;$claudeLocalBin"
        }
    }
}

Write-Host "[Claude] Instalando plugins..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    claude plugin install frontend-design@claude-plugins-official
    claude plugin install superpowers@claude-plugins-official
    claude plugin install context7@claude-plugins-official
    claude plugin install code-review@claude-plugins-official
}
else {
    Write-Host "  AVISO: CLI do Claude Code nao encontrado. O app Desktop (GUI) nao serve" -ForegroundColor Yellow
    Write-Host "  para isso -- instale o CLI com: irm https://claude.ai/install.ps1 | iex" -ForegroundColor Yellow
    Write-Host "  Depois, rode este instalador de novo ou instale manualmente dentro do CLI:"
    Write-Host "    /plugin install frontend-design@claude-plugins-official"
    Write-Host "    /plugin install superpowers@claude-plugins-official"
    Write-Host "    /plugin install context7@claude-plugins-official"
    Write-Host "    /plugin install code-review@claude-plugins-official"
}

Write-Host ""
Write-Host "Instalacao concluida. Reinicie o Claude para aplicar as mudancas." -ForegroundColor Green
