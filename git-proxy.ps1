# git-proxy.ps1 - Git Proxy Manager (HTTP / HTTPS / SOCKS5)
#
# Usage:
#   .\git-proxy.ps1 -h <IP> -p <PORT> -t <TYPE> -s      Set proxy (apply immediately)
#   .\git-proxy.ps1 -u                                    Unset proxy
#   .\git-proxy.ps1 -c                                    Show current proxy status
#   .\git-proxy.ps1 -Help                                 Show help
#
# Examples:
#   .\git-proxy.ps1 -h 127.0.0.1 -p 1080 -t socks5 -s
#   .\git-proxy.ps1 -h 127.0.0.1 -p 7890 -t http -s
#   .\git-proxy.ps1 -h proxy.example.com -p 8080 -t https -s
#   .\git-proxy.ps1 -u

param(
    [Alias("h")][string]$ProxyHost,
    [Alias("p")][int]$ProxyPort,
    [Alias("t")][ValidateSet("http","https","socks5")][string]$ProxyType = "socks5",
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
Git Proxy Manager (HTTP / HTTPS / SOCKS5)

Usage:
    .\git-proxy.ps1 -h <IP> -p <PORT> -t <TYPE> -s      Set proxy (apply immediately)
    .\git-proxy.ps1 -u                                    Unset proxy
    .\git-proxy.ps1 -c                                    Show current proxy status
    .\git-proxy.ps1 -Help                                 Show this help

Parameters:
    -h, -ProxyHost    Proxy server IP or hostname (e.g. 127.0.0.1)
    -p, -ProxyPort    Proxy port (e.g. 1080)
    -t, -ProxyType    Proxy protocol: http | https | socks5 (default: socks5)
    -s, -Set          Apply proxy settings to Git
    -u, -Unset        Unset Git proxy
    -c, -Check        Show current proxy status
    -Help             Show this help

Supported Protocols:
    socks5    SOCKS5 proxy (recommended, works for both http/https git repos)
    http      HTTP proxy (e.g. Clash/SSR HTTP port 7890)
    https     HTTPS proxy (less common)

Examples:
    # SOCKS5 proxy (default)
    .\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
    .\git-proxy.ps1 -h 127.0.0.1 -p 10808 -t socks5 -s

    # HTTP proxy (Clash default port)
    .\git-proxy.ps1 -h 127.0.0.1 -p 7890 -t http -s

    # HTTPS proxy
    .\git-proxy.ps1 -h proxy.example.com -p 8080 -t https -s

    # Unset
    .\git-proxy.ps1 -u

    # Check status
    .\git-proxy.ps1 -c

Notes:
    - Only modifies git config (global ~/.gitconfig), not system env vars
    - Sets both http.proxy and https.proxy
    - Apply takes effect immediately
    - For SOCKS5, the URL prefix is socks5://
    - For HTTP, the URL prefix is http://
    - For HTTPS proxy, the URL prefix is https://
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
    param([string]$ProxyHost, [int]$ProxyPort, [string]$ProxyType)

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

    # Validate protocol type
    $validTypes = @("http","https","socks5")
    if ($ProxyType -notin $validTypes) {
        Write-Err "Invalid proxy type: $ProxyType (must be one of: http, https, socks5)"
        exit 1
    }

    $proxyUrl = "${ProxyType}://${ProxyHost}:${ProxyPort}"

    Write-Info "Setting $ProxyType proxy: $proxyUrl"

    try {
        git config --global http.proxy  $proxyUrl
        git config --global https.proxy $proxyUrl
        Write-OK "Proxy set successfully (effective immediately)"
        Write-Host ""
        Write-Host "  Protocol   = $ProxyType" -ForegroundColor Gray
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
            # Parse proxy URL: protocol://host:port
            if ($httpProxy -match '^(https?|socks5)://([^:]+):(\d+)$') {
                $proto  = $Matches[1]
                $testHost = $Matches[2]
                $testPort = [int]$Matches[3]
                $tcp = New-Object System.Net.Sockets.TcpClient
                $iar = $tcp.BeginConnect($testHost, $testPort, $null, $null)
                $success = $iar.AsyncWaitHandle.WaitOne(2000, $false)
                if ($success -and $tcp.Connected) {
                    Write-OK ("Proxy {0}://{1}:{2} is reachable" -f $proto, $testHost, $testPort)
                    $tcp.Close()
                }
                else {
                    Write-Warn ("Proxy {0}://{1}:{2} is NOT reachable" -f $proto, $testHost, $testPort)
                    $tcp.Close()
                }
            }
            else {
                Write-Warn "Proxy URL format not recognized: $httpProxy"
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
    Set-GitProxyInternal -ProxyHost $ProxyHost -ProxyPort $ProxyPort -ProxyType $ProxyType
}
elseif ($Unset) {
    Unset-GitProxyInternal
}
elseif ($Check) {
    Show-GitProxyStatus
}
elseif ($ProxyHost -or $ProxyPort) {
    Write-Err "Incomplete arguments: need -h <IP> -p <port> -t <type> -s"
    Show-Help
    exit 1
}