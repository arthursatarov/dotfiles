# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Import modules
Import-Module -Name Terminal-Icons

# PSReadLine config
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Oh My Psh Config
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\1_shell.omp.json" | Invoke-Expression

# Aliases
Set-Alias c clear
Set-Alias ll ls
Set-Alias vi nvim
Set-Alias vim nvim
Set-Alias cat Get-Content

# Functions
function wgs ($package) { # winget search $package
  winget search $package
}

function wgi ($package, $source) { # winget install $package
  winget install $package -s $source
}


