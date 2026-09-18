# test-proxy-protocols.ps1
# 对比 HTTP 和 SOCKS5 代理在 git clone HTTPS 仓库时的表现
#
# 用法:
#   .\test-proxy-protocols.ps1 -HttpProxy <IP>:<PORT> -SocksProxy <IP>:<PORT>
#
# 示例:
#   .\test-proxy-protocols.ps1 -HttpProxy 1.2.3.4:80 -SocksProxy 5.6.7.8:1080

param(
    [Parameter(Mandatory)][string]$HttpProxy,
    [Parameter(Mandatory)][string]$SocksProxy
)

function Test-Proxy {
    param(
        [string]$Name,
        [string]$ProxyUrl,
        [string]$TestDir
    )

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  测试 $Name ($ProxyUrl)" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan

    # 1. 设置 git 代理
    git config --global --unset-all http.proxy  2>$null
    git config --global --unset-all https.proxy 2>$null
    git config --global http.proxy  $ProxyUrl
    git config --global https.proxy $ProxyUrl
    Write-Host "[设置] git proxy = $ProxyUrl" -ForegroundColor Gray

    # 2. 准备测试目录
    Set-Location "$env:USERPROFILE\Downloads"
    if (Test-Path $TestDir) {
        Remove-Item $TestDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    # 3. 测试 git clone (HTTPS 仓库)
    Write-Host "[测试] git clone https://github.com/octocat/Hello-World.git ..." -ForegroundColor Yellow
    $startTime = Get-Date
    try {
        $output = git clone --depth 1 "https://github.com/octocat/Hello-World.git" $TestDir 2>&1 | Out-String
        $elapsed = (Get-Date) - $startTime

        if (Test-Path $TestDir) {
            Write-Host "[结果] ✅ 成功 (用时 $($elapsed.TotalSeconds)s)" -ForegroundColor Green
            Write-Host "        $output" -ForegroundColor Gray
            Remove-Item $TestDir -Recurse -Force -ErrorAction SilentlyContinue
            return $true
        }
        else {
            Write-Host "[结果] ❌ 失败 (用时 $($elapsed.TotalSeconds)s)" -ForegroundColor Red
            Write-Host "        $output" -ForegroundColor Gray
            return $false
        }
    }
    catch {
        Write-Host "[结果] ❌ 异常: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main test flow - run both tests first, then summarize
$httpResult = Test-Proxy -Name "HTTP Proxy" -ProxyUrl "http://$HttpProxy" -TestDir "test-http-clone"
$socksResult = Test-Proxy -Name "SOCKS5 Proxy" -ProxyUrl "socks5://$SocksProxy" -TestDir "test-socks-clone"
$results = @{ Http = $httpResult; Socks = $socksResult }

# 清理 git 配置
git config --global --unset-all http.proxy  2>$null
git config --global --unset-all https.proxy 2>$null

# 汇总
$httpColor = if ($results.Http) { 'Green' } else { 'Red' }
$socksColor = if ($results.Socks) { 'Green' } else { 'Red' }
$httpResult = if ($results.Http) { '[OK] support' } else { '[FAIL] not support' }
$socksResult = if ($results.Socks) { '[OK] support' } else { '[FAIL] not support' }

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Test Summary" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  HTTP proxy  ($HttpProxy):     $httpResult" -ForegroundColor $httpColor
Write-Host "  SOCKS5 proxy ($SocksProxy): $socksResult" -ForegroundColor $socksColor

Write-Host ""
Write-Host "Conclusion:" -ForegroundColor Cyan
if ($results.Http -and $results.Socks) {
    Write-Host "  Both protocols support HTTPS git repos" -ForegroundColor Green
}
elseif (-not $results.Http -and $results.Socks) {
    Write-Host "  HTTP proxy does NOT support HTTPS CONNECT tunnel (GitHub requires HTTPS)" -ForegroundColor Yellow
    Write-Host "  SOCKS5 proxy supports any TCP traffic, recommended" -ForegroundColor Green
}
elseif ($results.Http -and -not $results.Socks) {
    Write-Host "  SOCKS5 proxy unreachable, but HTTP works" -ForegroundColor Yellow
}
else {
    Write-Host "  Both proxies failed - network issue or proxy dead" -ForegroundColor Red
}