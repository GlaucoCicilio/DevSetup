# setup-projtest.ps1
# Script para setup automático do ProjTst
# Data: 2026-05-20

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Cores para output
$Colors = @{
    Success = 'Green'
    Error   = 'Red'
    Warning = 'Yellow'
    Info    = 'Cyan'
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Type = 'Info'
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = $Colors[$Type]
    Write-Host "[$timestamp] " -NoNewline
    Write-Host $Message -ForegroundColor $color
}

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Prerequisites {
    Write-Log "Verificando pré-requisitos..." Info
    
    $required = @('git', 'cmake', 'ninja', 'pwsh')
    $missing = @()
    
    foreach ($cmd in $required) {
        if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
            $missing += $cmd
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Log "Comandos faltando: $($missing -join ', ')" Error
        Write-Log "Execute o DevSetup antes de continuar" Warning
        return $false
    }
    
    Write-Log "✓ Todos os pré-requisitos estão presentes" Success
    return $true
}

function New-ProjectDirectory {
    param([string]$Path)
    
    if (Test-Path $Path) {
        Write-Log "Diretório já existe: $Path" Warning
        $response = Read-Host "Deseja remover e recriá-lo? (S/N)"
        
        if ($response -eq 'S' -or $response -eq 's') {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction SilentlyContinue
            Write-Log "Diretório removido" Info
        } else {
            return $false
        }
    }
    
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Write-Log "✓ Diretório criado: $Path" Success
    return $true
}

function Initialize-GitRepository {
    param([string]$Path)
    
    Write-Log "Inicializando repositório Git..." Info
    
    Set-Location $Path
    
    git init | Out-Null
    git config user.name "GlaucoCicilio" 2>$null | Out-Null
    git config user.email "euanimal@hotmail.com" 2>$null | Out-Null
    
    Write-Log "✓ Repositório Git inicializado" Success
}

function Copy-TemplateFiles {
    param(
        [string]$SourcePath,
        [string]$DestPath
    )
    
    Write-Log "Copiando arquivos de template..." Info
    
    $files = @(
        '.vscode/settings.json',
        '.vscode/launch.json',
        '.vscode/tasks.json',
        '.vscode/extensions.json',
        'CMakeLists.txt',
        'src/main.cpp',
        'include/app.h',
        '.gitignore',
        'README.md'
    )
    
    foreach ($file in $files) {
        $sourceFile = Join-Path $SourcePath $file
        $destFile = Join-Path $DestPath $file
        $destDir = Split-Path $destFile
        
        if (-not (Test-Path $sourceFile)) {
            Write-Log "Arquivo de template não encontrado: $file" Warning
            continue
        }
        
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        Copy-Item -Path $sourceFile -Destination $destFile -Force
        Write-Log "  ✓ $file" Success
    }
    
    Write-Log "✓ Arquivos de template copiados" Success
}

function Create-GitIgnore {
    param([string]$Path)
    
    Write-Log "Criando arquivos iniciais..." Info
    
    $gitkeepFiles = @(
        'src/.gitkeep',
        'include/.gitkeep',
        'build/.gitkeep'
    )
    
    foreach ($file in $gitkeepFiles) {
        $filePath = Join-Path $Path $file
        $dirPath = Split-Path $filePath
        
        if (-not (Test-Path $dirPath)) {
            New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
        }
        
        if (-not (Test-Path $filePath)) {
            New-Item -ItemType File -Path $filePath -Force | Out-Null
        }
    }
    
    Write-Log "✓ Estrutura de diretórios criada" Success
}

function Initialize-FirstCommit {
    param([string]$Path)
    
    Write-Log "Criando primeiro commit..." Info
    
    Set-Location $Path
    
    git add . 2>&1 | Out-Null
    git commit -m "Initial commit: ProjTst template com C++23, MSVC, CMake e Ninja" 2>&1 | Out-Null
    
    Write-Log "✓ Primeiro commit criado" Success
}

function Show-NextSteps {
    param([string]$ProjectPath)
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║          ✓ ProjTst Configurado com Sucesso!               ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Log "Próximos passos:" Info
    Write-Host ""
    Write-Host "1️⃣  Criar repositório no GitHub" -ForegroundColor Yellow
    Write-Host "   • Acesse: https://github.com/new" -ForegroundColor White
    Write-Host "   • Nome: ProjTst" -ForegroundColor White
    Write-Host "   • Descrição: Projeto de Teste C++23 com MSVC e MySQL" -ForegroundColor White
    Write-Host ""
    
    Write-Host "2️⃣  Conectar repositório remoto" -ForegroundColor Yellow
    Write-Host "   cd $ProjectPath" -ForegroundColor White
    Write-Host "   git remote add origin https://github.com/GlaucoCicilio/ProjTst.git" -ForegroundColor White
    Write-Host "   git branch -M main" -ForegroundColor White
    Write-Host "   git push -u origin main" -ForegroundColor White
    Write-Host ""
    
    Write-Host "3️⃣  Abrir no VS Code" -ForegroundColor Yellow
    Write-Host "   code $ProjectPath" -ForegroundColor White
    Write-Host ""
    
    Write-Host "4️⃣  Compilar e testar" -ForegroundColor Yellow
    Write-Host "   • Pressione Ctrl+Shift+B para compilar" -ForegroundColor White
    Write-Host "   • Pressione F5 para debugar" -ForegroundColor White
    Write-Host ""
    
    Write-Host "5️⃣  Instalar extensões VS Code" -ForegroundColor Yellow
    Write-Host "   • VS Code sugere automaticamente" -ForegroundColor White
    Write-Host "   • Ou instale manualmente da aba Extensions" -ForegroundColor White
    Write-Host ""
    
    Write-Host "📚 Documentação completa em: $ProjectPath\README.md" -ForegroundColor Cyan
    Write-Host ""
}

# ============================================================================
# MAIN SCRIPT
# ============================================================================

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║    ProjTst Setup - C++23 with MSVC, MySQL & CMake         ║" -ForegroundColor Cyan
Write-Host "║    Data: 2026-05-20                                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar privilégios de admin
if (-not (Test-Administrator)) {
    Write-Log "Aviso: Recomenda-se executar como Administrator" Warning
}

# Definir caminhos
$DevSetupRoot = "D:\DevSetup"
$TemplateRoot = Join-Path $DevSetupRoot "templates\ProjTst"
$ProjectRoot = "D:\AppTst\ProjTst"

# Verificar se DevSetup existe
if (-not (Test-Path $DevSetupRoot)) {
    Write-Log "DevSetup não encontrado em: $DevSetupRoot" Error
    exit 1
}

Write-Log "DevSetup encontrado: $DevSetupRoot" Success

# Verificar pré-requisitos
if (-not (Test-Prerequisites)) {
    exit 1
}

# Perguntar por caminhos customizados
Write-Host ""
$customPath = Read-Host "Deseja usar caminho customizado? Padrão: $ProjectRoot (S/N)"
if ($customPath -eq 'S' -or $customPath -eq 's') {
    $ProjectRoot = Read-Host "Informe o caminho do projeto"
}

# Criar diretório
if (-not (New-ProjectDirectory $ProjectRoot)) {
    Write-Log "Abortado pelo usuário" Warning
    exit 0
}

# Inicializar Git
Initialize-GitRepository $ProjectRoot

# Copiar arquivos de template
Copy-TemplateFiles $TemplateRoot $ProjectRoot

# Criar estrutura de diretórios
Create-GitIgnore $ProjectRoot

# Criar primeiro commit
Initialize-FirstCommit $ProjectRoot

# Mostrar próximos passos
Show-NextSteps $ProjectRoot

Write-Log "Setup concluído em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" Success
Write-Host ""
