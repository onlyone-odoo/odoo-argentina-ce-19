# Be OnlyOne — helper for Odoo 19 CE + this Argentina CE fork (WSL Ubuntu-24.04)
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet("bootstrap", "init", "drop", "start", "stop", "logs", "shell")]
    [string]$Command,

    [string]$DbName = "arce19_dev",
    [string]$Modules = "l10n_ar,l10n_ar_afipws,l10n_ar_afipws_fe"
)

$ErrorActionPreference = "Stop"
$Distro = "Ubuntu-24.04"
$ForkRoot = "/mnt/c/Users/Matias/Desktop/github/odoo-argentina-ce-fork"
$ScriptDir = "$ForkRoot/dev/wsl"

function Invoke-WslBash([string]$BashCommand) {
    & wsl -d $Distro -u root -- bash -lc $BashCommand
    if ($LASTEXITCODE -ne 0) {
        throw "WSL command failed with exit code $LASTEXITCODE"
    }
}

switch ($Command) {
    "bootstrap" {
        Invoke-WslBash "sed -i 's/\r$//' $ScriptDir/*.sh && chmod +x $ScriptDir/*.sh && $ScriptDir/bootstrap.sh"
    }
    "init" {
        Invoke-WslBash "DB_NAME='$DbName' MODULES='$Modules' $ScriptDir/init-db.sh"
    }
    "drop" {
        Invoke-WslBash "DB_NAME='$DbName' $ScriptDir/drop-db.sh"
    }
    "start" {
        Invoke-WslBash "DB_NAME='$DbName' $ScriptDir/start.sh"
    }
    "stop" {
        Invoke-WslBash "$ScriptDir/stop.sh"
    }
    "logs" {
        Invoke-WslBash "tail -n 100 `$HOME/arce19.log"
    }
    "shell" {
        & wsl -d $Distro -u root
    }
}
