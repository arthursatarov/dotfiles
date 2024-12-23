# ===============================
# Module Installation and Import
# ===============================
# Ensure Terminal-Icons module is installed before importing
if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}

Import-Module -Name Terminal-Icons

# ===============================
# PSReadLine Configuration
# ===============================
# Configure PSReadLine options for enhanced terminal experience
$PSReadLineOptions = @{
  EditMode                      = 'Windows'
  HistoryNoDuplicates           = $true
  HistorySearchCursorMovesToEnd = $true
  PredictionSource              = 'HistoryAndPlugin' # Enhanced prediction source
  PredictionViewStyle           = 'ListView'
  BellStyle                     = 'None'
  MaximumHistoryCount           = 10000 # Increased history capacity
}

Set-PSReadLineOption @PSReadLineOptions

# Configure custom key bindings
Set-PSReadLineKeyHandler -Key UpArrow       -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow     -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab           -Function MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+d'    -Function DeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+w'    -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord 'Alt+d'     -Function DeleteWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+z'    -Function Undo
Set-PSReadLineKeyHandler -Chord 'Ctrl+y'    -Function Redo

# ===============================
# Prompt and Shell Enhancements
# ===============================
# Configure Starship prompt
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship.toml"
$ENV:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

# Invoke-Expression (&starship init powershell)

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/1_shell.omp.json" | Invoke-Expression

# ===============================
# Additional Tools
# ===============================
# Initialize Zoxide (smart directory changer)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# ===============================
# Custom Functions
# ===============================
# Function to quickly update PowerShell profile
function Update-Profile {
  & $profile
}