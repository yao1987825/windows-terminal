# git-proxy.ps1 - Git SOCKS5 Proxy Manager
#
# Usage:
#   .\git-proxy.ps1 -h <IP> -p <PORT> -s      Set SOCKS5 proxy (apply immediately)
#   .\git-proxy.ps1 -u                        Unset proxy
#   .\git-proxy.ps1 -c                        Show current proxy status
#   .\git-proxy.ps1 -Help                     Show help
#
# Examples:
#   .\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
#   .\git-proxy.ps1 -u

param(
    [Alias("h")][string]$ProxyHost,
    [Alias("p")][int]$ProxyPort,
    [Alias("s")][switch]$Set,
    [Alias("u")][switch]$Unset,
    [Alias("c")][switch]$Check,
    [switch]$Help
)

# ========== Color Functions ==========
function Write-Info { param($msg) Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-OK   { param($msg) Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Err  { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

# ========== Help ==========
function Show-Help {
@"
Git SOCKS5 Proxy Manager

Usage:
    .\git-proxy.ps1 -h <IP> -p <PORT> -s      Set SOCKS5 proxy (apply immediately)
    .\git-proxy.ps1 -u                        Unset proxy
    .\git-proxy.ps1 -c                        Show current proxy status
    .\git-proxy.ps1 -Help                     Show this help

Parameters:
    -h, -ProxyHost    Proxy server IP or hostname (e.g. 127.0.0.1)
    -p, -ProxyPort    Proxy port (e.g. 1080)
    -s, -Set          Apply proxy settings to Git
    -u, -Unset        Unset Git proxy
    -c, -Check        Show current proxy status
    -Help             Show this help

Examples:
    .\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
    .\git-proxy.ps1 -h 192.168.1.100 -p 10808 -s
    .\git-proxy.ps1 -u
    .\git-proxy.ps1 -c

Notes:
    - Only modifies git config (global ~/.gitconfig), not system env vars
    - Sets both http.proxy and https.proxy
    - Uses socks5 protocol
    - Apply takes effect immediately
"@
}

# ========== Check Git ==========
function Test-GitInstalled {
    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Write-Err "Git not found. Please install Git for Windows first."
        Write-Info "Download: https://git-scm.com/download/win"
        exit 1
    }
}

# ========== Set Proxy ==========
function Set-GitProxyInternal {
    param([string]$ProxyHost, [int]$ProxyPort)

    if (-not $ProxyHost -or -not $ProxyPort) {
        Write-Err "Setting proxy requires -h <IP> and -p <port>"
        Show-Help
        exit 1
    }

    # Validate IP / domain
    $ipRegex = '^(\d{1,3}\.){3}\d{1,3}$'
    $domainRegex = '^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$'
    if ($ProxyHost -notmatch $ipRegex -and $ProxyHost -notmatch $domainRegex) {
        Write-Err "Invalid proxy host: $ProxyHost"
        exit 1
    }

    # Validate port
    if ($ProxyPort -lt 1 -or $ProxyPort -gt 65535) {
        Write-Err "Invalid port: $ProxyPort (range 1-65535)"
        exit 1
    }

    $proxyUrl = "socks5://${ProxyHost}:${ProxyPort}"

    Write-Info "Setting SOCKS5 proxy: $proxyUrl"

    try {
        git config --global http.proxy  $proxyUrl
        git config --global https.proxy $proxyUrl
        Write-OK "Proxy set successfully (effective immediately)"
        Write-Host ""
        Write-Host "  http.proxy  = $proxyUrl" -ForegroundColor Gray
        Write-Host "  https.proxy = $proxyUrl" -ForegroundColor Gray
    }
    catch {
        Write-Err "Failed to set proxy: $($_.Exception.Message)"
        exit 1
    }
}

# ========== Unset Proxy ==========
function Unset-GitProxyInternal {
    Write-Info "Unsetting Git proxy..."

    try {
        git config --global --unset http.proxy  2>$null
        git config --global --unset https.proxy 2>$null
        Write-OK "Proxy unset successfully"
    }
    catch {
        Write-Err "Failed to unset proxy: $($_.Exception.Message)"
        exit 1
    }
}

# ========== Show Status ==========
function Show-GitProxyStatus {
    Write-Info "Current Git proxy configuration:"
    Write-Host ""
    Write-Host "  http.proxy  = $(git config --global --get http.proxy)"  -ForegroundColor Gray
    Write-Host "  https.proxy = $(git config --global --get https.proxy)" -ForegroundColor Gray
    Write-Host ""

    # Test proxy connectivity
    $httpProxy  = git config --global --get http.proxy
    if ($httpProxy) {
        Write-Info "Testing proxy connectivity..."
        try {
            if ($httpProxy -match 'socks5://([^:]+):(\d+)') {
                $testHost = $Matches[1]
                $testPort = [int]$Matches[2]
                $tcp = New-Object System.Net.Sockets.TcpClient
                $iar = $tcp.BeginConnect($testHost, $testPort, $null, $null)
                $success = $iar.AsyncWaitHandle.WaitOne(2000, $false)
                if ($success -and $tcp.Connected) {
                    Write-OK "Proxy $testHost`:$testPort is reachable"
                    $tcp.Close()
                }
                else {
                    Write-Warn "Proxy $testHost`:$testPort is NOT reachable"
                    $tcp.Close()
                }
            }
        }
        catch {
            Write-Warn "Connectivity test failed: $($_.Exception.Message)"
        }
    }
    else {
        Write-Warn "No proxy currently set"
    }
}

# ========== Main Logic ==========
Test-GitInstalled

# Show help if no args or -Help
if ($Help -or (-not $ProxyHost -and -not $Set -and -not $Unset -and -not $Check)) {
    Show-Help
    exit 0
}

if ($Set) {
    Set-GitProxyInternal -ProxyHost $ProxyHost -ProxyPort $ProxyPort
}
elseif ($Unset) {
    Unset-GitProxyInternal
}
elseif ($Check) {
    Show-GitProxyStatus
}
elseif ($ProxyHost -or $ProxyPort) {
    Write-Err "Incomplete arguments: need -h <IP> -p <port> -s"
    Show-Help
    exit 1
}