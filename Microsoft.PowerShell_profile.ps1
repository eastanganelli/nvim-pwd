## Variables
$DEV = $Env:WINAPPS
$DEPTHAI = $Env:DEPTHAI
$MODEL_REPO = "zelk12/Caveman_gemma-4-E2B_checkpoint-5550-Q6_K-GGUF"
$MODEL_FILE = "caveman_gemma-4-e2b_checkpoint-5550-q6_k.gguf"
## $PYTHON = $Env:PYTHON

## Imports
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History

## Installers
function ModuleInstallers () {
   winget install --id JanDeDobbeleer.OhMyPosh
   # winget install --id Neovim.Neovim
   winget install --id junegunn.fzf
   # git clone https://github.com/github/copilot.vim.git $HOME/AppData/Local/nvim/pack/github/start/copilot.vim
   winget install --id JesseDuffield.lazygit
   # Install-Module discordrpc -Scope CurrentUser
   . $profile
}

function omp_default_theme() {
   oh-my-posh init pwsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/1_shell.omp.json | Invoke-Expression
}

## Ultilities (Optional)
function which ($command) {
   Get-Command -Name $command -ErrorAction SilentlyContinue |
      Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Cleaning {
   Invoke-Expression clear
   $Ui = (Get-Host).UI.RawUI
   $Height = $UI.WindowSize.Height
   $Coordinates = New-Object System.Management.Automation.Host.Coordinates 0,($Height - 1)
   $Ui.CursorPosition = $Coordinates
}

function oakcam {
   python $DEPTHAI"\depthai_demo.py" --app=uvc
}

function Llama {
   ## llama-cli.exe --hf-repo $MODEL_REPO --hf-file $MODEL_FILE -t 4 -fa on --mlock --prio 3 --ctx-size 8192 --batch-size 1024 --ubatch-size 256 --no-mmap -cnv
   llama-cli.exe --hf-repo $MODEL_REPO --hf-file $MODEL_FILE
}

function LlamaServer {
   ## llama-server.exe --hf-repo $MODEL_REPO --hf-file $MODEL_FILE -t 4 -fa on --mlock --prio 3 --ctx-size 10240 --batch-size 1024 --ubatch-size 256 --jinja --cache-reuse 0 --alias qwen3 --port 8080
   llama-server.exe --hf-repo $MODEL_REPO --hf-file $MODEL_FILE --alias qwen3 --port 8080
}

function CodeAider {
   aider --openai-api-base http://localhost:8080/v1 --openai-api-key no-key-needed --model openai/qwen3 --edit-format whole
}

function CloudAider {
   aider --model openrouter/z-ai/glm-4.5-air:free --edit-format whole
}

function ctt {
   irm christitus.com/win | iex
}

## Alias (Optional)
Set-Alias g git
Set-Alias ll ls
Set-Alias grep findstr
New-Alias -Name clr -Value Cleaning

## Oh My Posh
omp_default_theme
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
   Import-Module "$ChocolateyProfile"
}

## Discord Presence
## $params = @{
## Details      = "Version $($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
## State        = (Split-Path -Path $pwd -Leaf)
## Start        = "Now"
## UpdateScript = {
##       Update-DSRichPresence -State (Split-Path -Path $pwd -Leaf)
##    }
## }
## Start-DSClient @params

clr