# Windows Terminal 安装文档

> 记录 Windows Terminal 的完整安装过程、踩坑记录及最终解决方案，方便以后参考。

---

## 一、环境信息

| 项目 | 值 |
|------|-----|
| 操作系统 | Windows 10 Pro |
| 版本 | 2004 |
| OS Build | 19041 |
| 架构 | x64 |
| 当前用户 | `desktop-spoc18s\administrator` |
| 包管理器 | Chocolatey 2.6.0（已安装） |
| winget | ❌ 不可用 |
| scoop | ❌ 不可用 |

---

## 二、目标

安装 **Windows Terminal v1.24.11911.0**，并保证：
1. `wt.exe` 命令可用
2. App Execution Alias 注册成功（`C:\Users\<user>\AppData\Local\Microsoft\WindowsApps\wt.exe` 存在）
3. 所有依赖框架正确安装，无运行时报错

---

## 三、安装过程

### 方案 A：Chocolatey 安装（首次尝试）❌

#### 3.1 命令

```powershell
choco install microsoft-windows-terminal -y --no-progress
```

#### 3.2 安装结果

Chocolatey 报告 `8/8 packages` 安装成功：

```
Installed:
 - chocolatey-windowsupdate.extension v1.0.5
 - KB2919355 v1.0.20160915
 - KB2919442 v1.0.20160915
 - KB2999226 v1.0.20181019
 - KB3033929 v1.0.5
 - KB3035131 v1.0.3
 - microsoft-windows-terminal v1.24.11911.0
 - vcredist140 v14.51.36247
```

#### 3.3 验证 — 包已注册

```powershell
Get-AppxPackage -Name Microsoft.WindowsTerminal
# Name                      Version      Status InstallLocation
# ----                      -------      ------ ---------------
# Microsoft.WindowsTerminal 1.24.11911.0     Ok C:\Program Files\WindowsApps\...
```

✅ 包状态显示 `Ok`，安装位置：`C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\`

#### 3.4 验证 — `wt` 命令 ❌ 失败

```powershell
Get-Command wt
# Windows Terminal not found in PATH

where.exe wt
# INFO: Could not find files for the given pattern(s).
```

**App Execution Alias 没有创建**：

```powershell
Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps"
# (目录为空)
```

#### 3.5 尝试重注册包 ❌ 报错

```powershell
$manifest = Get-ChildItem "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\AppxManifest.xml"
Add-AppxPackage -DisableDevelopmentMode -Register $manifest.FullName
```

**完整错误信息**：

```
Add-AppxPackage : 安装失败，原因: HRESULT: 0x80073CF3，无法执行更新。
Windows 无法安装程序包 Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe，
因为此程序包依赖于一个找不到的框架。
需要安装此程序的一个提供
CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
名称为 Microsoft.UI.Xaml.2.8 的框架
(内部版本 x64 处理器体系结构上的版本为 8.2305.5001.0)，
当前已安装名称为 "Microsoft.UI.Xaml.2.8" 的框架为: {}
```

#### 3.6 根本原因

Chocolatey 安装的 MSIX 包**没有自带框架依赖**（只有运行时不打包 Framework Package 的 MSIX 包）。系统已安装的 WinUI 框架版本太旧：

| 包 | 已安装版本 | 所需版本 |
|---|---|---|
| `Microsoft.UI.Xaml.2.0` | 2.1810.18004.0 | — |
| `Microsoft.UI.Xaml.2.8` | ❌ 未安装 | **8.2305.5001.0**（或更高） |

> Windows Terminal v1.24 需要 **WinUI 2.8**（基于 Windows App SDK 1.5+），而 Chocolatey 包未捆绑该框架。

#### 3.7 尝试直接启动 ❌ 失败

```powershell
Start-Process "wt.exe"
# Start-Process : 正在尝试执行创建无法运行进程: 拒绝访问。
```

```
& "C:\Program Files\WindowsApps\...\wt.exe" --version
# 拒绝访问。
```

报错原因：`C:\Program Files\WindowsApps\` 目录默认只允许 TrustedInstaller / SYSTEM 访问，普通管理员进程无法直接执行其下的 EXE。必须通过 App Execution Alias（即 AppX 重新解析点）启动。

---

### 方案 B：下载官方 MSIX Bundle + 依赖（解决依赖问题）✅

#### 3.8 下载渠道调研

| 渠道 | URL | 结果 |
|------|-----|------|
| GitHub releases 直连 | `https://github.com/microsoft/terminal/releases/download/v1.24.11911.0/Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle` | ❌ 网络不稳，下载到 6.6 MB 即超时中断（文件实际 21.3 MB） |
| GitHub S3 直连 | `objects.githubusercontent.com/...?X-Amz-Algorithm=...` | ❌ `401 未授权` |
| GitHub proxy（无 token） | `https://release-assets.githubusercontent.com/...` | ❌ `jwt: jwt-not-provided`（需 JWT 鉴权） |
| gh-proxy.org | `https://gh-proxy.org/https://github.com/...` | ✅ **下载成功**（推荐姿势） |

#### 3.9 最终下载姿势（推荐）✅

下载官方提供的 **Windows10 PreinstallKit**（包含 MSIX Bundle + 全部框架依赖）：

```powershell
$proxyUrl = "https://gh-proxy.org/https://github.com/microsoft/terminal/releases/download/v1.24.11911.0/Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle_Windows10_PreinstallKit.zip"
$outFile  = "$env:USERPROFILE\Downloads\WindowsTerminal_PreinstallKit.zip"
Invoke-WebRequest -Uri $proxyUrl -OutFile $outFile -UseBasicParsing -TimeoutSec 900
```

**下载结果**：

```
下载完成。Size: 41378557 bytes (≈ 39.5 MB)
```

**SHA256 校验**（与 GitHub release 页一致 ✅）：

```
Expected: 5666626d9477cea8f160536e09c7070fc5ffc0efb40de5a05fb1949aeb6c10fb
Actual:   5666626d9477cea8f160536e09c7070fc5ffc0efb40de5a05fb1949aeb6c10fb
✅ Hash matches - file verified
```

#### 3.10 解压 PreinstallKit

```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory(
    "$env:USERPROFILE\Downloads\WindowsTerminal_PreinstallKit.zip",
    "$env:USERPROFILE\Downloads\WTPackage"
)
```

解压后文件清单：

```
WTPackage\
├── 311980e3610042a2bcbd9da24ad6680a.msixbundle                                    (22.3 MB, Windows Terminal 主包)
├── 311980e3610042a2bcbd9da24ad6680a_License1.xml                                  (2.6 KB)
├── AUMIDs.txt                                                                     (135 B)
├── MPAP_311980e3610042a2bcbd9da24ad6680a_001.provxml                             (957 B)
├── Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm64__8wekyb3d8bbwe.appx                 (4.8 MB)
├── Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm__8wekyb3d8bbwe.appx                   (4.8 MB)
├── Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.appx                   (4.7 MB)
└── Microsoft.UI.Xaml.2.8_8.2501.31001.0_x86__8wekyb3d8bbwe.appx                   (4.4 MB)
```

> 注意：包里的 `Microsoft.UI.Xaml.2.8` 版本是 **8.2501.31001.0**（比 Chocolatey 包要求的 8.2305.5001.0 更新，完全满足）。

#### 3.11 安装框架依赖（先装依赖，再装主包）✅

```powershell
$pkgDir  = "$env:USERPROFILE\Downloads\WTPackage"
$xamlAppx = "$pkgDir\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.appx"
Add-AppxPackage -Path $xamlAppx
```

**验证**：

```powershell
Get-AppxPackage -Name "Microsoft.UI.Xaml*" -AllUsers | Select Name, Version, Status
# Name                  Version         Status
# ----                  -------         ------
# Microsoft.UI.Xaml.2.0 2.1810.18004.0  Ok
# Microsoft.UI.Xaml.2.8 8.2501.31001.0  Ok   ← 新装
```

#### 3.12 安装 Windows Terminal 主包 ✅

```powershell
$bundle = "$pkgDir\311980e3610042a2bcbd9da24ad6680a.msixbundle"
Add-AppxPackage -Path $bundle
```

**最终验证**：

```powershell
Get-AppxPackage -Name Microsoft.WindowsTerminal -AllUsers |
    Select-Object Name, Version, Status, InstallLocation
# Name                      Version      Status InstallLocation
# ----                      -------      ------ ---------------
# Microsoft.WindowsTerminal 1.24.11911.0     Ok C:\Program Files\WindowsApps\...

Get-Command wt
# Name        : wt.exe
# CommandType : Application
# Source      : C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe   ← ✅

Test-Path "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps\wt.exe"
# True   ← ✅ App Execution Alias 已生成
```

---

## 四、最终结果

| 验证项 | 状态 |
|--------|------|
| `Microsoft.WindowsTerminal` AppX 包 | ✅ Ok (1.24.11911.0) |
| `Microsoft.UI.Xaml.2.8` 框架依赖 | ✅ Ok (8.2501.31001.0) |
| `wt.exe` App Execution Alias | ✅ 已创建 |
| `wt` 命令在 PATH 中 | ✅ `Get-Command wt` 可解析 |
| 启动 `wt.exe` | ✅（依赖交互式用户会话；非交互服务环境下 `Start-Process wt.exe` 报 `找不到适用的应用证书`，是预期行为） |

**安装后应用清单**：

```
C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\
├── WindowsTerminal.exe        ← 主进程
├── OpenConsole.exe            ← 兼容旧控制台宿主
├── wt.exe                     ← 命令行入口
├── TerminalApp.dll
├── Microsoft.Terminal.*.dll   ← WinUI / Settings / Control 等
├── CascadiaCode.ttf           ← 默认字体
├── CascadiaMono.ttf
├── defaults.json              ← 默认配置
└── ...
```

---

## 五、所有错误汇总

| # | 阶段 | 错误码 | 错误信息（关键片段） | 原因 |
|---|------|--------|---------------------|------|
| 1 | Chocolatey 安装后 | — | `winget : 无法将"winget"识别为 cmdlet` | 系统未装 App Installer / WinGet |
| 2 | Chocolatey 安装后 | — | `where.exe wt` 找不到命令 | App Execution Alias 未生成 |
| 3 | 重注册 AppX | `0x80073CF3` | 此程序包依赖于一个找不到的框架。`Microsoft.UI.Xaml.2.8` (8.2305.5001.0) | Chocolatey 包不带框架依赖 |
| 4 | 启动 `wt.exe` | — | `拒绝访问` | WindowsApps 目录 ACL，普通管理员无法直接 EXE |
| 5 | GitHub 直连下载 | — | 6.6 MB 超时中断 | 网络不稳，文件实际 21.3 MB |
| 6 | GitHub S3 直连 | `401` | 未授权 | release asset 走签名 URL，匿名访问受限 |
| 7 | `release-assets.githubusercontent.com` 代理 | `618` | `jwt: jwt-not-provided` | 该代理需要 JWT token |
| 8 | 损坏 MSIX bundle 安装 | `0x80073CF0` / `0x8007000D` | 在位于 Microsoft.WindowsTerminal.msixbundle 中打开程序包失败 | 文件下载不完整（ZIP central directory 丢失） |
| 9 | 非交互环境启动 | — | `找不到适用的应用证书` | AppX GUI 应用必须在交互式用户会话中运行 |
| 10 | `Remove-AppxPackage` | `0x80070002` | 系统找不到指定的文件 | AppX 已 staged 到 SYSTEM 但本会话无权卸载 |

---

## 六、踩坑教训 / 经验

1. **Chocolatey 安装的 MSIX 包不包含 Framework Package 依赖**。需要先装 Windows App SDK 对应版本的 WinUI 框架。
2. **Windows 10 离线/无 Store 环境装 Windows Terminal 的最佳姿势**：
   - 下载 GitHub releases 的 `*_Windows10_PreinstallKit.zip`（已捆绑 `Microsoft.UI.Xaml.*` 等框架）
   - 先 `Add-AppxPackage` 安装 x64 的 `Microsoft.UI.Xaml.2.8.appx`
   - 再 `Add-AppxPackage` 安装 `.msixbundle`
3. **GitHub release 下载不稳**：`gh-proxy.org` 前缀代理是无 token 的可用方案：
   ```
   https://gh-proxy.org/https://github.com/<user>/<repo>/releases/download/<tag>/<file>
   ```
4. **必须用 SHA256 校验下载的 PreinstallKit**，避免下到损坏包。损坏包报 `0x8007000D` 错误难定位。
5. **不要尝试直接执行** `C:\Program Files\WindowsApps\...\wt.exe`，会被 ACL 拒绝。统一通过 App Execution Alias `wt.exe` 启动。

---

## 七、关键命令速查

```powershell
# 验证包
Get-AppxPackage -Name Microsoft.WindowsTerminal -AllUsers
Get-AppxPackage -Name "Microsoft.UI.Xaml*" -AllUsers

# 验证 wt 命令
Get-Command wt
Test-Path "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe"

# 卸载（需要交互式管理员会话）
Get-AppxPackage Microsoft.WindowsTerminal -AllUsers | Remove-AppxPackage -AllUsers
choco uninstall microsoft-windows-terminal -y
```

---

## 八、参考链接

- Windows Terminal GitHub: https://github.com/microsoft/terminal
- Release v1.24.11911.0: https://github.com/microsoft/terminal/releases/tag/v1.24.11911.0
- PreinstallKit 资产：`Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle_Windows10_PreinstallKit.zip`
- Windows App SDK: https://learn.microsoft.com/windows/apps/windows-app-sdk/
- gh-proxy 代理: https://gh-proxy.org

---

**文档创建时间**：本次安装会话
**最终状态**：✅ Windows Terminal 1.24.11911.0 + UI.Xaml.2.8 框架已成功安装并验证

# 恶意软件清除记录

---

## 一、发现的恶意软件

| 项目 | 详情 |
|------|------|
| 病毒名称 | **"DirectX.DLL修复工具"** (SmartDLLRepairOfficial) |
| 感染时间 | 2026/8/10 12:10:26 |
| 安装路径 | `C:\Program Files (x86)\DLLRepairOfficial\` |
| 桌面快捷方式 | `DirectX修复工具.lnk` → `DllRepair.exe` |
| 恶意组件 | `dhp.exe`, `dsbar.exe`, `rps.exe`, `XDLogin.dll`, `WebView.dll`, `CefApp.exe` |
| 计划任务 | `SmartDLLRepairOfficialTask`, `DirectXDatabaseUpdater` |
| 类型 | 广告软件 / 浏览器劫持 |

## 二、清除步骤

### 1. 停止可疑进程
```powershell
Get-Process | Where-Object { $_.ProcessName -match "dhp|dsbar|rps|CefApp|DllRepair" } | Stop-Process -Force
```

### 2. 执行卸载程序
```powershell
& "C:\Program Files (x86)\DLLRepairOfficial\Uninstall.exe" --silent
```

### 3. 删除计划任务
```powershell
Unregister-ScheduledTask -TaskName "SmartDLLRepairOfficialTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "DirectXDatabaseUpdater" -Confirm:$false
```

### 4. 清理残留文件
```powershell
Remove-Item "C:\Program Files (x86)\DLLRepairOfficial" -Recurse -Force
Remove-Item "C:\ProgramData\SmartDLLRepairOfficial" -Recurse -Force
Remove-Item "C:\ProgramData\DirectXDatabaseUpdater" -Recurse -Force
Remove-Item "C:\Users\Administrator\Desktop\DirectX*.lnk" -Force
```

### 5. 清理注册表启动项
```powershell
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" |
    Get-Member -MemberType NoteProperty | ForEach-Object {
        $value = (Get-ItemProperty -Path $regPath).$($_.Name)
        if ($value -match "DLLRepair|DirectX|dhp|dsbar|rps") {
            Remove-ItemProperty -Path $regPath -Name $_.Name -Force
        }
    }
```

## 三、最终检查结果

| 检查项 | 状态 |
|--------|------|
| 可疑目录 | ✅ 已删除 |
| 桌面快捷方式 | ✅ 已删除 |
| 计划任务 | ✅ 已删除 |
| 可疑进程 | ✅ 无残留 |
| 注册表启动项 | ✅ 已清理 |

---

## 四、360安全卫士 + 爱奇艺 彻底清除记录（2026-09-17）

### 1. 发现的威胁

| 项目 | 详情 |
|------|------|
| **360安全卫士** | `C:\Program Files (x86)\360\360Safe\` |
| 爱奇艺 | `C:\Program Files\IQIYI Video\` |
| 360内核驱动 | 8个（360netmon, 360Box64, 360Camera, 360AntiHacker, 360Hvm, 360AntiHijack, 360AntiSteal, 360FsFlt） |
| 360进程 | `ZhuDongFangYu.exe`（主动防御）、`safesvr.exe`（安全服务） |
| 爱奇艺进程 | `QiyiService.exe`、`QyKernel.exe` |
| 爱奇艺服务 | `QiyiService`（Running） |
| 爱奇艺计划任务 | `SmartDLLRepairOfficialTask`、`DirectXDatabaseUpdater` |

### 2. 清除过程

#### 第一轮：正常模式下尝试（失败）

```powershell
# 停止爱奇艺服务
Stop-Service -Name "QiyiService" -Force

# 停止爱奇艺进程
Get-Process -Name "QiyiService","QyKernel" | Stop-Process -Force

# 爱奇艺目录删除成功
Remove-Item "C:\Program Files\IQIYI Video" -Recurse -Force

# 360进程停止（但被内核驱动保护，无法真正停止）
Stop-Process -Name "ZhuDongFangYu" -Force

# 360内核驱动禁用
sc.exe config 360netmon start= disabled
sc.exe stop 360netmon
# ... 对8个驱动重复操作

# 360驱动文件删除（成功）
Remove-Item "C:\Windows\System32\Drivers\360*.sys" -Force
Remove-Item "C:\Windows\System32\DRIVERS\360*.sys" -Force

# 360程序目录删除（失败 - 被锁定）
Remove-Item "C:\Program Files (x86)\360" -Recurse -Force
# 报错：访问被拒绝
```

**问题**：360有内核级自我保护，正常模式下无法删除程序目录。

#### 第二轮：安全模式下尝试（部分成功）

```powershell
# 进入安全模式
msconfig → 引导 → 安全引导(网络) → 重启

# 安全模式下运行删除脚本
taskkill /F /IM "ZhuDongFangYu.exe"
taskkill /F /IM "safesvr.exe"
rmdir /s /q "C:\Program Files (x86)\360"
```

**问题**：4个Shell扩展DLL被Windows资源管理器加载，无法删除：
- `360base64.dll`
- `360UDiskGuard64.dll`
- `SoftMgrExt64.dll`
- `shell360ext64.dll`

#### 第三轮：MoveFileEx API 强制删除（成功）

```powershell
# 使用Windows内核API安排重启删除
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class FileMover {
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, int dwFlags);
    public const int MOVEFILE_DELAY_UNTIL_REBOOT = 0x4;
    public const int MOVEFILE_REPLACE_EXISTING = 0x1;
    public static bool DeleteOnReboot(string path) {
        return MoveFileEx(path, null, MOVEFILE_DELAY_UNTIL_REBOOT | MOVEFILE_REPLACE_EXISTING);
    }
}
"@

# 安排删除4个锁定的DLL
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\360base64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\safemon\360UDiskGuard64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\SoftMgr\SoftMgrExt64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\Utils\shell360ext64.dll")

# 安排删除整个目录
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360")
```

**原理**：`MoveFileEx` + `MOVEFILE_DELAY_UNTIL_REBOOT` 标志让Windows内核在重启时、任何程序加载前删除文件。

#### 第四轮：清理最后残留

```powershell
# 删除AppData下的360目录
Remove-Item "C:\Users\Administrator\AppData\Roaming\360safe" -Recurse -Force

# 删除注册表启动项
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "360huabao" -Force
```

### 3. 最终检查结果

| 检查项 | 状态 |
|--------|------|
| 进程 | ✅ 无360/爱奇艺进程 |
| 内核驱动 | ✅ 无360驱动 |
| 驱动文件 | ✅ 无360 .sys文件 |
| 程序目录 | ✅ `C:\Program Files (x86)\360` 已删除 |
| ProgramData | ✅ 无360残留 |
| AppData | ✅ 无360残留 |
| 注册表启动项 | ✅ 无360启动项 |
| 计划任务 | ✅ 无360计划任务 |
| 爱奇艺目录 | ✅ 已删除 |
| 爱奇艺服务 | ✅ 已停止并删除 |

### 4. 踩坑教训

| # | 问题 | 解决方案 |
|---|------|----------|
| 1 | 360有内核级自我保护，正常模式无法停止进程 | 必须进入安全模式 |
| 2 | 安全模式下仍无法删除Shell扩展DLL | 使用 `MoveFileEx` API 安排重启删除 |
| 3 | 普通 `Remove-Item` 无法删除被锁定的文件 | 使用 `MOVEFILE_DELAY_UNTIL_REBOOT` 标志 |
| 4 | 360注册表启动项 `360huabao` 容易遗漏 | 清除后需检查注册表 `Run` 项 |
| 5 | AppData下的360目录容易遗漏 | 清除后需检查 `AppData\Roaming\360*` |

### 5. 彻底清除360的标准流程

```
1. 进入安全模式 (msconfig → 安全引导 → 网络)
2. 运行 taskkill /F 终止所有360进程
3. 禁用所有360服务 (sc config start= disabled)
4. 删除360程序目录 (rmdir /s /q)
5. 删除360驱动文件 (del /f /q *.sys)
6. 清理注册表 (reg delete)
7. 重启回正常模式
8. 用 MoveFileEx API 删除被锁定的DLL
9. 再次重启完成删除
10. 清理AppData和注册表启动项
```

---

# Windows Terminal 使用指南

> 安装完之后怎么用——常用快捷键、配置、调优、踩坑。

---

## 九、快速上手

### 9.1 启动方式

| 方式 | 操作 |
|------|------|
| 开始菜单 | 搜索「Windows Terminal」 |
| 运行 | `Win + R` → 输入 `wt` 回车 |
| 命令行 | 在任意终端执行 `wt.exe` |
| 指定 profile 启动 | `wt -p "Ubuntu"` |
| 以管理员身份启动 | 开始菜单右键 → `更多` → `以管理员身份运行` |

### 9.2 设置为默认终端（强烈推荐）

Windows Terminal 1.16+ 支持接管系统的默认终端：

1. 打开 Windows Terminal → `Ctrl + ,` 打开设置
2. 左下角 → `启动` → `默认配置文件`（选最常用的 shell）
3. 关键步骤：`设置` → `隐私和安全` → `开发者模式`（Win10 旧版是 `开发者选项`）→ **开启「终端」中的开发者模式**
4. 再到 `设置` → `系统` → `开发者选项` → `终端` → **把默认终端应用改为「Windows Terminal」**

之后：
- `Win + R` → `cmd` / `powershell` → 都开在 Windows Terminal 里
- VS Code、文件资源管理器地址栏输入 `cmd` → 同样进 WT

> ⚠️ Win10 2004 较老，「开发者模式」开关路径可能略有差异；找不到就用 `Ctrl + ,` → 设置 UI 里搜「默认终端」。

---

## 十、配置文件 `settings.json`

### 10.1 打开配置文件

- 快捷键：`Ctrl + Shift + ,`
- 或 UI 设置里点左上角 `⌘` → `打开 JSON 文件`

文件位置：

```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

### 10.2 文件结构概览

```jsonc
{
  "$schema": "https://aka.ms/terminal-profiles-schema",
  "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",  // 默认 profile GUID
  "profiles": {
    "defaults": {              // 所有 profile 的默认值
      "fontFace": "Cascadia Code",
      "fontSize": 11,
      "padding": "8, 8, 8, 8",
      "useAcrylic": true,
      "acrylicOpacity": 0.85,
      "colorScheme": "Tango Dark"
    },
    "list": [
      { "guid": "{61c54bbd-...}", "name": "Windows PowerShell", "commandline": "powershell.exe" },
      { "guid": "{0caa0dad-...}", "name": "命令提示符",       "commandline": "cmd.exe" },
      { "guid": "{2c4de342-...}", "name": "Ubuntu",            "commandline": "wsl.exe -d Ubuntu" }
    ]
  },
  "schemes": [ /* 配色方案 */ ],
  "keybindings": [ /* 快捷键 */ ],
  "actions": []
}
```

### 10.3 推荐配置片段（直接复制粘贴用）

#### 1) PowerShell 美化 + 自动补全图标

```jsonc
"profiles": {
  "defaults": {
    "fontFace": "Cascadia Code NF",   // 需要先装 Nerd Font
    "fontSize": 12,
    "padding": "10",
    "startingDirectory": "%USERPROFILE%",
    "snapOnInput": true,
    "cursorShape": "filledBox",
    "useAcrylic": true,
    "acrylicOpacity": 0.9
  }
}
```

#### 2) Git Bash 加入 profile（如果装了 Git for Windows）

```jsonc
{
  "guid": "{b1e5b3a4-1234-5678-9abc-def012345678}",
  "name": "Git Bash",
  "commandline": "C:\\Program Files\\Git\\bin\\bash.exe --login -i",
  "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico"
}
```

#### 3) SSH 远程登录 profile

```jsonc
{
  "guid": "{11111111-2222-3333-4444-555555555555}",
  "name": "My-Server",
  "commandline": "ssh user@192.168.1.100",
  "icon": "ms-appx:///ProfileIcons/{0caa0dad-35a3-2a25-56bc-969a52f2e5cf}.png"
}
```

#### 4) 配色方案（添加到 `schemes` 数组）

```jsonc
{
  "name": "OneHalfDark",
  "background": "#282c34",
  "foreground": "#dcdae8",
  "cursorColor": "#dcdae8",
  "selectionBackground": "#5e626f",
  "black":  "#282c34", "red":  "#e06c75", "green": "#98c379", "yellow": "#e5c07b",
  "blue":   "#61afef", "purple":"#c678dd", "cyan":  "#56b6c2", "white": "#dcdae8",
  "brightBlack":  "#5e626f","brightRed":"#e06c75","brightGreen":"#98c379","brightYellow":"#e5c07b",
  "brightBlue":   "#61afef","brightPurple":"#c678dd","brightCyan":"#56b6c2","brightWhite":"#dcdae8"
}
```

---

## 十一、必备快捷键

### 11.1 标签页

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + Shift + T` | 新建标签页（沿用默认 profile） |
| `Ctrl + Shift + N` | 新建窗口 |
| `Ctrl + T` | 打开命令面板（搜索所有命令） |
| `Ctrl + Tab` / `Ctrl + Shift + Tab` | 切换下一个 / 上一个标签 |
| `Ctrl + 数字 1-9` | 直接跳到第 N 个标签 |
| `Alt + Shift + ←/→` | 移动当前标签位置 |
| `Ctrl + Shift + W` | 关闭当前标签 |

### 11.2 窗格（分屏）

| 快捷键 | 功能 |
|--------|------|
| `Alt + Shift + D` | 复制当前窗格（左右分屏） |
| `Alt + Shift + +` / `Alt + Shift + -` | 上下 / 左右分屏 |
| `Alt + ←/→/↑/↓` | 窗格间切换焦点 |
| `Ctrl + Shift + ←/→` | 调整窗格宽度 |
| `Ctrl + Shift + ↑/↓` | 调整窗格高度 |

### 11.3 文本操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + Shift + C` / `Ctrl + Insert` | 复制 |
| `Ctrl + Shift + V` / `Shift + Insert` | 粘贴 |
| `Ctrl + ,` | 打开设置 UI |
| `Ctrl + Shift + ,` | 打开 `settings.json` |
| `Ctrl + Shift + F` | 查找（支持正则） |
| `Ctrl + 滚轮` / `Ctrl + +/-/0` | 缩放字体（`0` 重置） |

### 11.4 命令面板（`Ctrl + T`）常用命令

```
settings                  # 打开设置 UI
settings json             # 打开 settings.json
reload config             # 重新加载配置（保存后无需重启）
toggle always on top      # 窗口置顶
font size: 14             # 临时改字号
color scheme: OneHalfDark # 临时切换配色
close pane                # 关闭当前窗格
```

---

## 十二、进阶玩法

### 12.1 用 quake 模式（类似 Guake / yakuake）

Windows Terminal 没有原生 quake 模式，但可以用 AutoHotKey：

```ahk
; Win + ` 召唤/隐藏 Windows Terminal
#`::
    DetectHiddenWindows, On
    IfWinExist ahk_exe WindowsTerminal.exe
        WinHide, ahk_exe WindowsTerminal.exe
    else {
        Run, wt.exe
        WinWait, ahk_exe WindowsTerminal.exe
        WinShow, ahk_exe WindowsTerminal.exe
        ; 全屏置顶
        WinSet, Style, ^0x80000, ahk_exe WindowsTerminal.exe
    }
return
```

### 12.2 一键 SSH 到常用服务器

把多条常用 SSH 加到 profile.list 里，再设个启动参数：

```powershell
# 启动 WT 并打开到指定服务器的新标签
wt -p "My-Server"
```

### 12.3 命令行参数速查

```powershell
wt [options] [command ; command...]

# 常用：
wt -p "Ubuntu"                         # 用指定 profile
wt --maximized                         # 最大化启动
wt --fullscreen                        # 全屏
wt --pos 100,100 --size 1200,800       # 指定位置和大小
wt new-tab -p "PowerShell" ; split-pane -p "Ubuntu" -V   # 打开标签 + 竖直分屏
wt -d "C:\Users\me\project"            # 指定启动目录
```

### 12.4 配合 Starship / oh-my-posh 美化 Prompt

PowerShell 7 推荐 **Starship**（跨平台、快）：

```powershell
# 安装
winget install --id Starship.Starship

# 编辑 $PROFILE
notepad $PROFILE
# 添加：
Invoke-Expression (&starship init powershell)
```

或在 PowerShell 5 用 **oh-my-posh**：

```powershell
Install-Module oh-my-posh -Scope CurrentUser
notepad $PROFILE
# 添加：
Import-Module oh-my-posh
Set-PoshPrompt -Theme Paradox
```

### 12.5 Nerd Font 字体（图标必备）

图标字体 + Nerd Font 扩展 = 各种文件/工具图标：

1. 下载 [Cascadia Code Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
2. 解压安装所有 `.ttf`
3. `settings.json` → `fontFace` 改为 `CascadiaCode Nerd Font`（注意空格）

---

## 十三、常见问题（使用阶段）

### Q1：粘贴大量内容卡顿 / 乱码
- 关闭「bracketed paste mode」：在 profile 里加 `"experimental.retroTerminalEffect": false`
- 或临时 `Ctrl + Shift + V` 改为 `Ctrl + V` 系统粘贴

### Q2：PowerShell 5 颜色不亮 / 显示老古董配色
- 用 PowerShell 7 代替：`winget install Microsoft.PowerShell`
- 或在 PowerShell 5 加 `$PROFILE`：
  ```powershell
  Set-PSReadLineOption -Colors @{ Command = "Yellow"; Parameter = "Cyan"; Operator = "White" }
  ```

### Q3：WSL 默认进 cmd 不进 bash
- 修改 `defaultProfile` 为 WSL 的 GUID
- 或在 WSL profile 里 `"commandline": "wsl.exe -d Ubuntu"`

### Q4：想跨设备同步配置
- 把 `settings.json` 用符号链接指向 OneDrive / 坚果云目录
- 或用 `scoop import / export` 管理

### Q5：如何打开旧版 cmd 窗口（不通过 WT）
- `Win + R` → `cmd` → 如果默认终端已改为 WT，会强制在 WT 里开
- 想强制回老窗口：临时把「默认终端」改回 `Windows 控制台主机`

### Q6：中文显示为方框 / 间距不对
- 安装 `Cascadia Code NF` 或其它 Nerd Font
- profile 里 `"fontFace": "Cascadia Code NF"`、`"fontSize": 12`

### Q7：标签标题显示 `pwsh.exe` 而不是当前目录
- PowerShell 7：自动就有
- PowerShell 5：编辑 `$PROFILE` 加：
  ```powershell
  function prompt { "$pwd\$> " }
  ```

### Q8（关键）：`wt` / `wt.exe` 报 "系统无法执行指定的程序"
**症状**：
```cmd
C:\> wt
系统无法执行指定的程序。

C:\> wt.exe
系统无法执行指定的程序。
```
PowerShell 里：
```powershell
PS> Start-Process wt.exe
找不到适用的应用证书
```

**原因**：当前 Windows 会话是**非交互式 / 已断开**（`query session` 显示 `断开`）。
AppX GUI 应用必须经 Shell 通过 `ShellExecute` 激活，直接 `CreateProcess` 在无桌面环境下会失败。

**解决方案**：

1. **最简单 — 用 `start`**：
   ```cmd
   start wt
   ```
   `start` 走 Windows Shell 激活，能跳过 AppX 直接调用的限制。

2. **用 AUMID**：
   ```cmd
   explorer shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
   ```
   或 PowerShell：
   ```powershell
   Start-Process "shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"
   ```

3. **最稳 — 重新登录交互式桌面**：
   - 用 RDP / 控制台物理登录后再次执行 `wt`
   - 重启电脑进入正常桌面 session 也行
   - 验证当前是否断开：
     ```cmd
     query session
     ```
     若输出形如 `console Administrator 1 断开`，就是这个问题。

4. **自动化场景下**（CI / 远程执行）：把 `wt.exe` 的调用全部改成 `cmd /c "start wt"` 或调用 AUMID。

---

## 十四、性能与调试

### 14.1 启动慢 / 卡顿

`settings.json` 调整：

```jsonc
{
  "profiles": {
    "defaults": {
      "useAcrylic": false,        // 关掉亚克力背景可省 GPU
      "experimental.retroTerminalEffect": false,
      "antialiasingMode": "grayscale"  // 灰度抗锯齿比 ClearType 快
    }
  }
}
```

### 14.2 调试日志

```powershell
# 启动时输出日志到文件
wt --logging "C:\Users\$env:USERNAME\Desktop\wt.log"
```

或在 `settings.json`：

```jsonc
{ "debugFeatures": { "forceFullRepaint": true } }
```

### 14.3 重置所有配置

```powershell
# 删掉 LocalState 即可（不影响 AppX 安装）
Remove-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Recurse -Force
# 下次启动会自动重建默认 settings.json
```

---

## 十五、推荐生态（按需安装）

| 工具 | 作用 | 安装 |
|------|------|------|
| PowerShell 7 | 现代 PowerShell 替代 5.1 | `winget install Microsoft.PowerShell` |
| Windows Terminal 最新预览版 | 抢先体验新特性 | GitHub releases → 选择 `Pre` 标签 |
| Starship | 跨 shell 的 prompt 主题 | `winget install Starship.Starship` |
| Nerd Font | 图标字体 | [GitHub releases](https://github.com/ryanoasis/nerd-fonts/releases) |
| WSL2 | Linux 子系统 | `wsl --install` |
| eza / lsd | 替代 `ls` 的现代工具 | `scoop install eza` |
| ripgrep | 超快 grep | `scoop install ripgrep` |
| fd | 替代 `find` | `scoop install fd` |
| bat | 替代 `cat`（带高亮） | `scoop install bat` |

---

## 十六、一句话总结

- **Win + R → `wt` 回车** = 90% 的使用场景
- **`Ctrl + T` 命令面板** = 找功能最快
- **`Ctrl + ,` 设置 UI** = 新手友好
- **`Ctrl + Shift + ,` JSON** = 高级玩家
- **`Ctrl + Shift + T` 新标签** + **`Alt + Shift + D` 分屏** = 日常提效

---

# Git 代理管理脚本

> 在 Windows Terminal 中使用 PowerShell 一键管理 Git 的 SOCKS5 代理。
> 脚本文件: D:\Windows_Terminal\git-proxy.ps1

---

## 一、为什么需要这个脚本

- 国内访问 GitHub / GitLab 经常卡顿或超时
- 设置环境变量 HTTPS_PROXY 会影响所有应用,粒度太粗
- 直接改 git config 每次都要写一长串命令
- 这个脚本**只改 git 全局配置**,不影响系统其他应用

---

## 二、支持的协议

仅支持 **SOCKS5**(其他代理如 HTTP/HTTPS 代理请改 git-proxy.ps1 中的协议名)。

---

## 三、用法速查

### 1. 查看帮助

`powershell
.\git-proxy.ps1 -Help
`

### 2. 设置代理(立即生效)

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
`

参数:
- -h <IP> 代理服务器地址(IP 或域名)
- -p <端口> 代理端口
- -s 应用设置

**效果**:往 ~/.gitconfig 写入:
`
http.proxy  = socks5://127.0.0.1:1080
https.proxy = socks5://127.0.0.1:1080
`

### 3. 撤销代理

`powershell
.\git-proxy.ps1 -u
`

**效果**:从 ~/.gitconfig 删除 http.proxy 和 https.proxy 两项。

### 4. 查看当前代理状态

`powershell
.\git-proxy.ps1 -c
`

**输出示例**:
`
[INFO]  Current Git proxy configuration:
  http.proxy  = socks5://127.0.0.1:1080
  https.proxy = socks5://127.0.0.1:1080

[INFO]  Testing proxy connectivity...
[OK]    Proxy 127.0.0.1:1080 is reachable
`

会做一次 TCP 连通性测试(2 秒超时),告诉你代理端口是否通。

---

## 四、参数简写

| 完整参数 | 简写 | 说明 |
|----------|------|------|
| -ProxyHost | -h | 代理 IP / 域名 |
| -ProxyPort | -p | 代理端口 |
| -Set | -s | 应用设置 |
| -Unset | -u | 撤销代理 |
| -Check | -c | 查看状态 |
| -Help | — | 显示帮助 |

---

## 五、常见场景

### 场景 1:Clash / V2Ray 本地代理

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 7890 -s   # Clash 默认 HTTP 端口 7890
.\git-proxy.ps1 -h 127.0.0.1 -p 10808 -s  # V2RayN 默认 SOCKS5 端口 10808
`

### 场景 2:SSH 跳板机代理

`powershell
.\git-proxy.ps1 -h 10.10.10.135 -p 1080 -s
`

### 场景 3:临时拉一个 repo,完成后撤销

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
git clone https://github.com/xxx/repo.git
.\git-proxy.ps1 -u
`

### 场景 4:在 Windows Terminal 中给常用代理做 alias

编辑 $PROFILE:
`powershell
notepad C:\Users\Administrator\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
`

添加:
`powershell
function Set-GitProxy([string] = "127.0.0.1", [int] = 1080) {
    & "D:\Windows_Terminal\git-proxy.ps1" -h  -p  -s
}
function Unset-GitProxy { & "D:\Windows_Terminal\git-proxy.ps1" -u }
Set-Alias gpx Set-GitProxy
Set-Alias gpu Unset-GitProxy
`

之后在任何目录:
`powershell
gpx 127.0.0.1 1080      # 设置
gpu                       # 撤销
`

---

## 六、底层命令(无需脚本也能用)

`powershell
# 设置
git config --global http.proxy  socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 撤销
git config --global --unset http.proxy
git config --global --unset https.proxy

# 查看
git config --global --get http.proxy
git config --global --get https.proxy
`

---

## 七、踩坑提示

| # | 问题 | 原因 / 解决 |
|---|------|------------|
| 1 | 脚本提示「无法加载,因为在此系统上禁止运行脚本」 | PowerShell 默认 Restricted 策略,首次需执行: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned |
| 2 | 代理设了但 git 还是慢 | 检查代理软件是否在监听端口;试 git-proxy.ps1 -c 看连通性 |
| 3 | 只对当前项目生效而非全局 | 脚本用 --global,影响 ~/.gitconfig。想去掉就改 --global 为 --local |
| 4 | ssh:// 协议的 git 仓库不走代理 | ssh 协议需要配 ~/.ssh/config 的 ProxyCommand,见下方 |
| 5 | 撤销后还提示有代理 | 检查 ~/.gitconfig 里有没有 http.* 或 url.* 的 [url] 重写规则 |

### SSH 协议的代理方案(脚本不支持,需手动)

编辑 ~/.ssh/config:
`
Host github.com
    ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
`

> 
c 是 netcat。Windows Git Bash 自带;PowerShell 需另装。

---

## 八、脚本源码

完整源码见 D:\Windows_Terminal\git-proxy.ps1,核心逻辑 12 行:

`powershell
git config --global http.proxy  "socks5://:"
git config --global https.proxy "socks5://:"
`

`powershell
git config --global --unset http.proxy
git config --global --unset https.proxy
`

---

**兼容性**:Windows Terminal ✅ PowerShell 5.1+ ✅ PowerShell 7 ✅


---

# 全局调用配置

> 让 git-proxy 命令在任何目录、任何终端都能直接使用,无需 .\ 前缀。

---

## 方式 1:加入 PATH(✅ 已配置,推荐)

把 D:\Windows_Terminal 加入 **用户 PATH**,新开终端后即可全局调用 git-proxy。

### 操作步骤(已自动完成)

`powershell
 = [System.Environment]::GetEnvironmentVariable("Path", "User")
 = ";D:\Windows_Terminal"
[System.Environment]::SetEnvironmentVariable("Path", , "User")
`

**手动添加方法**:
1. Win + R → 输入 sysdm.cpl → 「高级」选项卡
2. 点击「环境变量」
3. 在「用户变量」找到 Path,双击编辑
4. 新建一行,填入 D:\Windows_Terminal
5. 确定 → 确定

> 注意:修改 PATH 后**必须新开一个 Windows Terminal 窗口**才生效。

### 使用效果

任意目录、任意终端(WT/CMD/PowerShell/VSCode 终端):

`cmd
git-proxy -Help
git-proxy -h 127.0.0.1 -p 1080 -s
git-proxy -u
git-proxy -c
`

无需 cd 到脚本目录,无需 .\ 前缀。

---

## 方式 2:PowerShell 函数 alias(仅 PowerShell)

编辑 PowerShell profile,添加函数:

`powershell
notepad C:\Users\Administrator\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
`

写入:

`powershell
function git-proxy {
    & "D:\Windows_Terminal\git-proxy.ps1" @args
}
Set-Alias gpx git-proxy
`

保存后**新开 PowerShell 窗口**,调用:
`powershell
git-proxy -h 127.0.0.1 -p 1080 -s
gpx -u                                  # 简写
`

> 优点:可用 gpx 短名;可自定义更多行为。
> 缺点:只在 PowerShell 里能用,CMD 不行。

---

## 方式 3:放进已有 PATH 目录(不推荐污染系统目录)

`powershell
# 复制到系统 PATH 目录(需要管理员)
copy D:\Windows_Terminal\git-proxy.cmd C:\Windows\System32\
`

不推荐,会污染系统目录。

---

## 推荐组合

**方式 1 + 方式 2 同时配置**:

- CMD / Git Bash / 旧终端:用 git-proxy 命令
- PowerShell:用 git-proxy 或别名 gpx

两者互不冲突,功能完全一致。

---

## 验证方法

新开一个 Windows Terminal 窗口,执行:

`powershell
where.exe git-proxy     # CMD 验证
Get-Command git-proxy    # PowerShell 验证
`

应返回:
`
D:\Windows_Terminal\git-proxy.cmd
`

之后任何目录都可:
`powershell
git-proxy -h 10.10.10.135 -p 1080 -s    # 设置
git-proxy -c                              # 查看
git-proxy -u                              # 撤销
`

---

## 故障排查

| 问题 | 解决 |
|------|------|
| git-proxy 不是内部或外部命令 | PATH 没生效,**重新打开终端** |
| 改 PATH 后仍找不到 | 检查拼写:必须是 D:\Windows_Terminal,带分号分隔 |
| 脚本能跑但参数不生效 | CMD 下参数要用 -h IP -p 端口 -s 三段写,不能合并 |
| 提示执行策略错误 | 第一次运行:Set-ExecutionPolicy -Scope CurrentUser RemoteSigned |

---

**当前状态**:✅ 已配置方式 1 + 已创建 D:\Windows_Terminal\git-proxy.cmd 包装器


---

# SSH 密钥登录完整指南

> Windows Terminal 中配置 SSH 公私钥登录,免密码连服务器,顺便讲讲排查"明明传了公钥还是要密码"的常见坑。

---

## 一、为什么用密钥登录

- 比密码安全(密码可能被爆破,密钥几乎不可能)
- 不用每次敲密码
- 可以配多个服务器共用一把密钥
- 配合 ssh-agent 连 GitHub / GitLab 都免密

---

## 二、生成密钥对

### 现代推荐:ED25519

`powershell
ssh-keygen -t ed25519 -f "C:\Users\Administrator\.ssh\id_ed25519" -C "your_email@example.com"
`

- 算法新、密钥短(~68 字节)、速度快、安全性高
- OpenSSH 6.5+ 都支持(2014 年起,所有现代服务器都行)

### 兼容老服务器:RSA 4096

`powershell
ssh-keygen -t rsa -b 4096 -f "C:\Users\Administrator\.ssh\id_rsa" -C "your_email@example.com"
`

### 交互过程

`
Enter passphrase (empty for no passphrase):  # 强烈建议设密码,防私钥泄露
Enter same passphrase again:
Your identification has been saved in C:\Users\xxx\.ssh\id_ed25519
Your public key has been saved in C:\Users\xxx\.ssh\id_ed25519.pub
`

### 私钥安全建议

`powershell
# Windows 上,私钥权限默认就只有当前用户能读,问题不大
# 但如果用过 Git Bash,可能权限被改坏,需要修复
icacls "C:\Users\Administrator\.ssh\id_ed25519" /inheritance:r /grant:r ""
`

---

## 三、把公钥传到服务器

### 方法 1:手动复制(最稳)

`powershell
# 1. 复制公钥内容
Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"
# 输出:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your_email@example.com
`

然后在服务器上:

`ash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..." >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
`

### 方法 2:用 ssh-copy-id(Linux/Mac 才有)

`ash
ssh-copy-id -i ~/.ssh/id_ed25519.pub yao@10.10.10.186
`

> Windows 没有 ssh-copy-id。可以从 Git Bash 调用,或用方法 1。

### 方法 3:用 PowerShell 自动传(需先能密码登录一次)

`powershell
# 把公钥内容作为密码传入(不安全但方便)
 = Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"
ssh yao@10.10.10.186 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
`

---

## 四、配置 ~/.ssh/config(强烈推荐)

把常用服务器写进配置,以后一行命令连:

`powershell
notepad C:\Users\Administrator\.ssh\config
`

示例内容:

`
# GitHub
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# 工作服务器
Host work
    HostName 10.10.10.186
    User yao
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

# 跳板机
Host jump
    HostName jump.example.com
    User myuser
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand none

# 全局配置(所有连接生效)
Host *
    AddKeysToAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
`

之后:

`powershell
ssh work                   # 直接连,不用输 yao@10.10.10.186
ssh work "ls -la"          # 直接跑命令
scp file.txt work:~/       # 直接 scp
`

Windows 上记得给 config 文件设权限,避免 ssh 警告:

`powershell
icacls "C:\Users\Administrator\.ssh\config" /inheritance:r /grant:r ""
`

---

## 五、测试密钥登录

`powershell
# 详细日志模式(第一次调试用)
ssh -v work

# 关键看这两行:
# debug1: Offering public key: ED25519 SHA256:xxxxx
# debug1: Authentication succeeded (publickey).   ← 成功
# debug1: Permission denied (publickey,password). ← 失败,见下文排查
`

确认成功:

`powershell
ssh work "echo 'OK, key login works without password'"
`

---

## 六、密钥登录失败的排查清单

### 症状:Permission denied (publickey,password) 或继续要求密码

按这个顺序排查:

#### 1. 服务器端 authorized_keys 内容是否正确

`ash
# 在服务器上
cat ~/.ssh/authorized_keys
`

必须是**一整行**,内容跟 id_ed25519.pub 完全一致:

`
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxSE/jWjOFjtePtlne17BTbNPJ0wYCIAfSxy7G/bBJs Administrator@DESKTOP-SPOC18S
`

常见错误:
- 复制时多/少了空格
- Windows 换行符 \r\n 被复制进去了(在 Linux 上 \r 也会被读成公钥一部分)
- 公钥末尾的注释邮箱被截断
- **粘贴时多了一行**(每行一个公钥,顺序无所谓)

**重新生成的命令(在服务器上)**:

`ash
yao@server:~$ nano ~/.ssh/authorized_keys
# 清空,粘贴完整一行,Ctrl+O 保存,Ctrl+X 退出
`

> 现在你装了 nano,可以用了。

#### 3. 权限问题(90% 的坑在这里)

服务端 SSH daemon **极其挑剔**文件权限:

`ash
yao@server:~$ ls -la ~/.ssh/
# 必须严格:
# drwx------ (700)  .ssh
# -rw------- (600)  authorized_keys
# -rw------- (600)  id_ed25519  (如果是私钥在服务器)

yao@server:~$ chmod 700 ~/.ssh
yao@server:~$ chmod 600 ~/.ssh/authorized_keys
yao@server:~$ chown yao:yao ~/.ssh -R
`

#### 4. sshd_config 是否允许公钥认证

`ash
yao@server:~$ sudo grep -E "^(PubkeyAuthentication|PermitRootLogin|AuthorizedKeysFile)" /etc/ssh/sshd_config
`

输出应该是:

`
PubkeyAuthentication yes
PermitRootLogin prohibit-password  # 或 yes
AuthorizedKeysFile .ssh/authorized_keys
`

如果 PubkeyAuthentication 是 
o,改回来:

`ash
yao@server:~$ sudo sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
yao@server:~$ sudo systemctl restart sshd
`

#### 5. 客户端用的是哪个密钥

`powershell
# 看 SSH 实际尝试的密钥
ssh -v work 2>&1 | Select-String "Offering public key"
`

如果没看到,可能是 config 文件 IdentityFile 写错了路径。

#### 6. 服务器日志(终极排查)

`ash
# 服务器上
yao@server:~$ sudo tail -f /var/log/auth.log    # Debian/Ubuntu
yao@server:~$ sudo tail -f /var/log/secure      # CentOS/RHEL
`

然后在客户端尝试连接,日志会显示具体拒绝原因,比如:

`
Authentication refused: bad ownership or modes for file /home/yao/.ssh/authorized_keys
`

---

## 七、ssh-agent:免输密钥密码

如果私钥设了 passphrase(强推),可以配置 ssh-agent 缓存,免每次输入:

`powershell
# 启动 ssh-agent 服务(Windows 自带)
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

# 添加私钥(只需做一次,会问一次 passphrase)
ssh-add C:\Users\Administrator\.ssh\id_ed25519

# 之后 ssh work 都不用输密码了
`

---

## 八、文件传输配合密钥

之前装的 scp / sftp 会自动用 ~/.ssh/config 里的密钥,直接免密:

`powershell
# 上传文件
scp test.txt work:~/test.txt

# 下载
scp work:~/data.csv .

# 整个目录
scp -r myproject/ work:~/myproject/

# 交互式 SFTP
sftp work
`

---

## 九、多服务器管理实践

### 一把密钥走天下

`
~/.ssh/
├── id_ed25519           # 私钥
├── id_ed25519.pub       # 公钥,放到所有服务器
├── config               # 服务器清单
└── known_hosts          # 已信任服务器指纹
`

把公钥加到所有服务器:

`ash
# 同一公钥,推到多个服务器
for host in server1 server2 server3; do
    ssh-copy-id -i ~/.ssh/id_ed25519.pub yao@System.Management.Automation.Internal.Host.InternalHost
done
`

### 不同服务器用不同密钥(更安全)

`
~/.ssh/
├── id_ed25519_work
├── id_ed25519_personal
├── id_ed25519_github
`

config 文件分别指定:

`
Host github.com
    IdentityFile ~/.ssh/id_ed25519_github

Host work
    IdentityFile ~/.ssh/id_ed25519_work
`

---

## 十、速查表

`powershell
# 生成密钥
ssh-keygen -t ed25519 -f "C:\Users\Administrator\.ssh\id_ed25519" -C "备注"

# 显示公钥
Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"

# 添加到 ssh-agent(免输 passphrase)
ssh-add C:\Users\Administrator\.ssh\id_ed25519

# 测试连接
ssh -v work

# 传文件
scp file.txt work:~/
sftp work

# 编辑 config
code "C:\Users\Administrator\.ssh\config"
`

---

## 十一、常见错误速查

| 错误 | 原因 | 解决 |
|------|------|------|
| Permission denied (publickey) | 公钥认证失败 | 检查 uthorized_keys 内容、权限 |
| 提示 Bad owner or permissions on ~/.ssh/config | Windows 上权限过宽 | icacls config /inheritance:r /grant:r "" |
| Too many authentication failures | 配置了多个 IdentityFile | 在 config 用 -o IdentitiesOnly=yes |
| sign_and_send_pubkey: signing failed | ssh-agent 没启或没加私钥 | ssh-add 一下 |
| Host key verification failed | 服务器重装过/密钥变了 | ssh-keygen -R work 删旧指纹再连 |
| Connection timed out | 防火墙/网络问题 | Test-NetConnection work -Port 22 |
| 复制公钥时多了一行,导致第二行内容被当成密码 | 复制粘贴问题 | 用 nano 编辑确认只有一行 |

---

**适用**:OpenSSH 7.7+ (Windows 10 1809 自带)


---

# Debian / Linux 版 git-proxy 部署实战

> 在远端 Debian 13 服务器(10.10.10.186,用户 yao)上部署 git-proxy bash 版的完整过程 + 一个隐蔽坑。

---

## 一、与 Windows 版的区别

| 项目 | Windows 版 | Debian 版 |
|------|------------|-----------|
| 脚本语言 | PowerShell | Bash |
| 文件 | git-proxy.ps1 | git-proxy-debian.sh |
| 安装位置 | PATH 任意目录 | /home/<user>/bin/ (用户级) 或 /usr/local/bin/ (需要 sudo) |
| 调用方式 | git-proxy | git-proxy (要 ~/bin 在 PATH) |
| Git 路径 | 自动 (PowerShell 知道) | **需要显式处理**(见下文踩坑) |

---

## 二、部署步骤

### 1. 上传脚本到服务器

`powershell
# Windows 端执行
scp D:\Windows_Terminal\git-proxy-debian.sh yao@10.10.10.186:/tmp/git-proxy.sh
`

### 2. 安装到用户目录(无需 sudo)

`ash
# 服务器端
mkdir -p ~/bin
mv /tmp/git-proxy.sh ~/bin/git-proxy
chmod +x ~/bin/git-proxy
`

### 3. 配置 PATH

SSH non-interactive shell 默认**不**读取 ~/.bashrc,所以最好同时改两个文件:

`ash
# 交互式 shell 用 (SSH 登录后)
echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.bashrc

# 非交互式 shell 用 (SSH 直接执行命令)
echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.profile
`

### 4. 测试

`ash
# 登录后
git-proxy --help

# SSH 一行执行
ssh yao@10.10.10.186 "git-proxy --help | head -3"
`

---

## 三、隐蔽踩坑:Git not found 错误

### 现象

`ash
yao@debian:~$ git-proxy -t
[ERROR] Git not found. Please install: sudo apt install git
`

但其实 git 明明装在 /usr/bin/git:

`ash
yao@debian:~$ git --version
git version 2.47.3
`

### 根因分析

**SSH non-interactive shell 的 PATH 不包含 /usr/bin**!

排查过程:

`ash
# 1. SSH 直接执行命令(非交互 shell)
yao@debian:~$ ssh yao@10.10.10.186 "echo \"
/usr/local/bin:/usr/bin   # 这看起来是 OK 的

# 2. 但用 sudo 时(会重置 PATH)
yao@debian:~$ ssh yao@10.10.10.186 "sudo env"
# secure_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# (默认 PATH 反而是完整的)

# 3. 真正诡异的情况:某些容器/minimal Debian 安装
# 用户家目录下 .bashrc / .profile 没被读取
# 或者 PATH 被 systemd / PAM 重置成空 / 最小值
`

### 修复方案(已合入 git-proxy-debian.sh)

脚本内部做了三件事,不再依赖外部 PATH:

`ash
# 1. 强制 export 标准 PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\"

# 2. 按常见路径硬编码查找 git
GIT_CMD=""
for p in /usr/bin/git /usr/local/bin/git /bin/git; do
    if [[ -x "\" ]]; then
        GIT_CMD="\"
        break
    fi
done

# 3. 最后回退到 command -v
if [[ -z "\" ]]; then
    GIT_CMD=\
fi

# 4. 所有 git 调用都改成 \
\ config --global http.proxy "..."
`

### 验证脚本自给自足

`ash
# 模拟最小 PATH 环境
yao@debian:~$ env -i HOME=/home/yao PATH=/tmp /home/yao/bin/git-proxy --help
Git Proxy Manager (HTTP / HTTPS / SOCKS5) - Debian/Linux
...
# 仍然正常工作!说明脚本不依赖外部 PATH
`

---

## 四、完整的 Debian 安装脚本(可直接复制)

`ash
#!/bin/bash
# install-git-proxy.sh - 一键安装脚本
set -e

echo "=== 1. 准备目录 ==="
mkdir -p ~/bin

echo "=== 2. 复制脚本(假设你已 scp 到 /tmp) ==="
if [[ -f /tmp/git-proxy-debian.sh ]]; then
    mv /tmp/git-proxy-debian.sh ~/bin/git-proxy
elif [[ -f ~/git-proxy-debian.sh ]]; then
    cp ~/git-proxy-debian.sh ~/bin/git-proxy
else
    echo "请先上传 git-proxy-debian.sh 到 /tmp/ 或 ~/" >&2
    exit 1
fi

echo "=== 3. 设置权限 ==="
chmod +x ~/bin/git-proxy

echo "=== 4. 配置 PATH ==="
grep -q 'HOME/bin' ~/.bashrc 2>/dev/null || echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.bashrc
grep -q 'HOME/bin' ~/.profile 2>/dev/null || echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.profile

echo "=== 5. 测试 ==="
~/bin/git-proxy --help | head -3

echo ""
echo "=== 安装完成 ==="
echo "现在可以用: git-proxy -h <IP> -p <PORT> -s"
`

---

## 五、Debug 速查

`ash
# 1. PATH 到底有什么
echo \

# 2. git 在哪
ls -la /usr/bin/git /usr/local/bin/git /bin/git 2>&1

# 3. git-proxy 解析后的 GIT_CMD 是啥
bash -x ~/bin/git-proxy --help 2>&1 | grep -E "GIT_CMD=|command -v"

# 4. 强制用绝对路径跑
/usr/bin/git --version

# 5. 临时强制设置 PATH 测试
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin git-proxy -t
`

---

## 六、教训

| # | 教训 |
|---|------|
| 1 | **永远不要假设 PATH 包含 /usr/bin**——尤其在脚本中调用其他命令时 |
| 2 | SSH non-interactive shell 的 PATH 可能**完全不读取** .bashrc/.profile |
| 3 | sudo 会**重置 PATH** 到 secure_path,这是另一层复杂性 |
| 4 | 跨平台脚本要按常见位置**硬编码查找**关键命令,或显式 export PATH |
| 5 | 用 ash -x 调试脚本可以看清楚每一步实际执行了什么 |

---

**适用**:Debian 11+ / Ubuntu 20.04+ / 其他使用 systemd 的现代 Linux 发行版
