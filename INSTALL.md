# Windows Terminal 瀹夎鏂囨。

> 璁板綍 Windows Terminal 鐨勫畬鏁村畨瑁呰繃绋嬨€佽俯鍧戣褰曞強鏈€缁堣В鍐虫柟妗堬紝鏂逛究浠ュ悗鍙傝€冦€?
---

## 涓€銆佺幆澧冧俊鎭?
| 椤圭洰 | 鍊?|
|------|-----|
| 鎿嶄綔绯荤粺 | Windows 10 Pro |
| 鐗堟湰 | 2004 |
| OS Build | 19041 |
| 鏋舵瀯 | x64 |
| 褰撳墠鐢ㄦ埛 | `desktop-spoc18s\administrator` |
| 鍖呯鐞嗗櫒 | Chocolatey 2.6.0锛堝凡瀹夎锛?|
| winget | 鉂?涓嶅彲鐢?|
| scoop | 鉂?涓嶅彲鐢?|

---

## 浜屻€佺洰鏍?
瀹夎 **Windows Terminal v1.24.11911.0**锛屽苟淇濊瘉锛?1. `wt.exe` 鍛戒护鍙敤
2. App Execution Alias 娉ㄥ唽鎴愬姛锛坄C:\Users\<user>\AppData\Local\Microsoft\WindowsApps\wt.exe` 瀛樺湪锛?3. 鎵€鏈変緷璧栨鏋舵纭畨瑁咃紝鏃犺繍琛屾椂鎶ラ敊

---

## 涓夈€佸畨瑁呰繃绋?
### 鏂规 A锛欳hocolatey 瀹夎锛堥娆″皾璇曪級鉂?
#### 3.1 鍛戒护

```powershell
choco install microsoft-windows-terminal -y --no-progress
```

#### 3.2 瀹夎缁撴灉

Chocolatey 鎶ュ憡 `8/8 packages` 瀹夎鎴愬姛锛?
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

#### 3.3 楠岃瘉 鈥?鍖呭凡娉ㄥ唽

```powershell
Get-AppxPackage -Name Microsoft.WindowsTerminal
# Name                      Version      Status InstallLocation
# ----                      -------      ------ ---------------
# Microsoft.WindowsTerminal 1.24.11911.0     Ok C:\Program Files\WindowsApps\...
```

鉁?鍖呯姸鎬佹樉绀?`Ok`锛屽畨瑁呬綅缃細`C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\`

#### 3.4 楠岃瘉 鈥?`wt` 鍛戒护 鉂?澶辫触

```powershell
Get-Command wt
# Windows Terminal not found in PATH

where.exe wt
# INFO: Could not find files for the given pattern(s).
```

**App Execution Alias 娌℃湁鍒涘缓**锛?
```powershell
Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps"
# (鐩綍涓虹┖)
```

#### 3.5 灏濊瘯閲嶆敞鍐屽寘 鉂?鎶ラ敊

```powershell
$manifest = Get-ChildItem "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\AppxManifest.xml"
Add-AppxPackage -DisableDevelopmentMode -Register $manifest.FullName
```

**瀹屾暣閿欒淇℃伅**锛?
```
Add-AppxPackage : 瀹夎澶辫触锛屽師鍥? HRESULT: 0x80073CF3锛屾棤娉曟墽琛屾洿鏂般€?Windows 鏃犳硶瀹夎绋嬪簭鍖?Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe锛?鍥犱负姝ょ▼搴忓寘渚濊禆浜庝竴涓壘涓嶅埌鐨勬鏋躲€?闇€瑕佸畨瑁呮绋嬪簭鐨勪竴涓彁渚?CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
鍚嶇О涓?Microsoft.UI.Xaml.2.8 鐨勬鏋?(鍐呴儴鐗堟湰 x64 澶勭悊鍣ㄤ綋绯荤粨鏋勪笂鐨勭増鏈负 8.2305.5001.0)锛?褰撳墠宸插畨瑁呭悕绉颁负 "Microsoft.UI.Xaml.2.8" 鐨勬鏋朵负: {}
```

#### 3.6 鏍规湰鍘熷洜

Chocolatey 瀹夎鐨?MSIX 鍖?*娌℃湁鑷甫妗嗘灦渚濊禆**锛堝彧鏈夎繍琛屾椂涓嶆墦鍖?Framework Package 鐨?MSIX 鍖咃級銆傜郴缁熷凡瀹夎鐨?WinUI 妗嗘灦鐗堟湰澶棫锛?
| 鍖?| 宸插畨瑁呯増鏈?| 鎵€闇€鐗堟湰 |
|---|---|---|
| `Microsoft.UI.Xaml.2.0` | 2.1810.18004.0 | 鈥?|
| `Microsoft.UI.Xaml.2.8` | 鉂?鏈畨瑁?| **8.2305.5001.0**锛堟垨鏇撮珮锛?|

> Windows Terminal v1.24 闇€瑕?**WinUI 2.8**锛堝熀浜?Windows App SDK 1.5+锛夛紝鑰?Chocolatey 鍖呮湭鎹嗙粦璇ユ鏋躲€?
#### 3.7 灏濊瘯鐩存帴鍚姩 鉂?澶辫触

```powershell
Start-Process "wt.exe"
# Start-Process : 姝ｅ湪灏濊瘯鎵ц鍒涘缓鏃犳硶杩愯杩涚▼: 鎷掔粷璁块棶銆?```

```
& "C:\Program Files\WindowsApps\...\wt.exe" --version
# 鎷掔粷璁块棶銆?```

鎶ラ敊鍘熷洜锛歚C:\Program Files\WindowsApps\` 鐩綍榛樿鍙厑璁?TrustedInstaller / SYSTEM 璁块棶锛屾櫘閫氱鐞嗗憳杩涚▼鏃犳硶鐩存帴鎵ц鍏朵笅鐨?EXE銆傚繀椤婚€氳繃 App Execution Alias锛堝嵆 AppX 閲嶆柊瑙ｆ瀽鐐癸級鍚姩銆?
---

### 鏂规 B锛氫笅杞藉畼鏂?MSIX Bundle + 渚濊禆锛堣В鍐充緷璧栭棶棰橈級鉁?
#### 3.8 涓嬭浇娓犻亾璋冪爺

| 娓犻亾 | URL | 缁撴灉 |
|------|-----|------|
| GitHub releases 鐩磋繛 | `https://github.com/microsoft/terminal/releases/download/v1.24.11911.0/Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle` | 鉂?缃戠粶涓嶇ǔ锛屼笅杞藉埌 6.6 MB 鍗宠秴鏃朵腑鏂紙鏂囦欢瀹為檯 21.3 MB锛?|
| GitHub S3 鐩磋繛 | `objects.githubusercontent.com/...?X-Amz-Algorithm=...` | 鉂?`401 鏈巿鏉僠 |
| GitHub proxy锛堟棤 token锛?| `https://release-assets.githubusercontent.com/...` | 鉂?`jwt: jwt-not-provided`锛堥渶 JWT 閴存潈锛?|
| gh-proxy.org | `https://gh-proxy.org/https://github.com/...` | 鉁?**涓嬭浇鎴愬姛**锛堟帹鑽愬Э鍔匡級 |

#### 3.9 鏈€缁堜笅杞藉Э鍔匡紙鎺ㄨ崘锛夆渽

涓嬭浇瀹樻柟鎻愪緵鐨?**Windows10 PreinstallKit**锛堝寘鍚?MSIX Bundle + 鍏ㄩ儴妗嗘灦渚濊禆锛夛細

```powershell
$proxyUrl = "https://gh-proxy.org/https://github.com/microsoft/terminal/releases/download/v1.24.11911.0/Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle_Windows10_PreinstallKit.zip"
$outFile  = "$env:USERPROFILE\Downloads\WindowsTerminal_PreinstallKit.zip"
Invoke-WebRequest -Uri $proxyUrl -OutFile $outFile -UseBasicParsing -TimeoutSec 900
```

**涓嬭浇缁撴灉**锛?
```
涓嬭浇瀹屾垚銆係ize: 41378557 bytes (鈮?39.5 MB)
```

**SHA256 鏍￠獙**锛堜笌 GitHub release 椤典竴鑷?鉁咃級锛?
```
Expected: 5666626d9477cea8f160536e09c7070fc5ffc0efb40de5a05fb1949aeb6c10fb
Actual:   5666626d9477cea8f160536e09c7070fc5ffc0efb40de5a05fb1949aeb6c10fb
鉁?Hash matches - file verified
```

#### 3.10 瑙ｅ帇 PreinstallKit

```powershell
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory(
    "$env:USERPROFILE\Downloads\WindowsTerminal_PreinstallKit.zip",
    "$env:USERPROFILE\Downloads\WTPackage"
)
```

瑙ｅ帇鍚庢枃浠舵竻鍗曪細

```
WTPackage\
鈹溾攢鈹€ 311980e3610042a2bcbd9da24ad6680a.msixbundle                                    (22.3 MB, Windows Terminal 涓诲寘)
鈹溾攢鈹€ 311980e3610042a2bcbd9da24ad6680a_License1.xml                                  (2.6 KB)
鈹溾攢鈹€ AUMIDs.txt                                                                     (135 B)
鈹溾攢鈹€ MPAP_311980e3610042a2bcbd9da24ad6680a_001.provxml                             (957 B)
鈹溾攢鈹€ Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm64__8wekyb3d8bbwe.appx                 (4.8 MB)
鈹溾攢鈹€ Microsoft.UI.Xaml.2.8_8.2501.31001.0_arm__8wekyb3d8bbwe.appx                   (4.8 MB)
鈹溾攢鈹€ Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.appx                   (4.7 MB)
鈹斺攢鈹€ Microsoft.UI.Xaml.2.8_8.2501.31001.0_x86__8wekyb3d8bbwe.appx                   (4.4 MB)
```

> 娉ㄦ剰锛氬寘閲岀殑 `Microsoft.UI.Xaml.2.8` 鐗堟湰鏄?**8.2501.31001.0**锛堟瘮 Chocolatey 鍖呰姹傜殑 8.2305.5001.0 鏇存柊锛屽畬鍏ㄦ弧瓒筹級銆?
#### 3.11 瀹夎妗嗘灦渚濊禆锛堝厛瑁呬緷璧栵紝鍐嶈涓诲寘锛夆渽

```powershell
$pkgDir  = "$env:USERPROFILE\Downloads\WTPackage"
$xamlAppx = "$pkgDir\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64__8wekyb3d8bbwe.appx"
Add-AppxPackage -Path $xamlAppx
```

**楠岃瘉**锛?
```powershell
Get-AppxPackage -Name "Microsoft.UI.Xaml*" -AllUsers | Select Name, Version, Status
# Name                  Version         Status
# ----                  -------         ------
# Microsoft.UI.Xaml.2.0 2.1810.18004.0  Ok
# Microsoft.UI.Xaml.2.8 8.2501.31001.0  Ok   鈫?鏂拌
```

#### 3.12 瀹夎 Windows Terminal 涓诲寘 鉁?
```powershell
$bundle = "$pkgDir\311980e3610042a2bcbd9da24ad6680a.msixbundle"
Add-AppxPackage -Path $bundle
```

**鏈€缁堥獙璇?*锛?
```powershell
Get-AppxPackage -Name Microsoft.WindowsTerminal -AllUsers |
    Select-Object Name, Version, Status, InstallLocation
# Name                      Version      Status InstallLocation
# ----                      -------      ------ ---------------
# Microsoft.WindowsTerminal 1.24.11911.0     Ok C:\Program Files\WindowsApps\...

Get-Command wt
# Name        : wt.exe
# CommandType : Application
# Source      : C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe   鈫?鉁?
Test-Path "C:\Users\$env:USERNAME\AppData\Local\Microsoft\WindowsApps\wt.exe"
# True   鈫?鉁?App Execution Alias 宸茬敓鎴?```

---

## 鍥涖€佹渶缁堢粨鏋?
| 楠岃瘉椤?| 鐘舵€?|
|--------|------|
| `Microsoft.WindowsTerminal` AppX 鍖?| 鉁?Ok (1.24.11911.0) |
| `Microsoft.UI.Xaml.2.8` 妗嗘灦渚濊禆 | 鉁?Ok (8.2501.31001.0) |
| `wt.exe` App Execution Alias | 鉁?宸插垱寤?|
| `wt` 鍛戒护鍦?PATH 涓?| 鉁?`Get-Command wt` 鍙В鏋?|
| 鍚姩 `wt.exe` | 鉁咃紙渚濊禆浜や簰寮忕敤鎴蜂細璇濓紱闈炰氦浜掓湇鍔＄幆澧冧笅 `Start-Process wt.exe` 鎶?`鎵句笉鍒伴€傜敤鐨勫簲鐢ㄨ瘉涔锛屾槸棰勬湡琛屼负锛?|

**瀹夎鍚庡簲鐢ㄦ竻鍗?*锛?
```
C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.24.11911.0_x64__8wekyb3d8bbwe\
鈹溾攢鈹€ WindowsTerminal.exe        鈫?涓昏繘绋?鈹溾攢鈹€ OpenConsole.exe            鈫?鍏煎鏃ф帶鍒跺彴瀹夸富
鈹溾攢鈹€ wt.exe                     鈫?鍛戒护琛屽叆鍙?鈹溾攢鈹€ TerminalApp.dll
鈹溾攢鈹€ Microsoft.Terminal.*.dll   鈫?WinUI / Settings / Control 绛?鈹溾攢鈹€ CascadiaCode.ttf           鈫?榛樿瀛椾綋
鈹溾攢鈹€ CascadiaMono.ttf
鈹溾攢鈹€ defaults.json              鈫?榛樿閰嶇疆
鈹斺攢鈹€ ...
```

---

## 浜斻€佹墍鏈夐敊璇眹鎬?
| # | 闃舵 | 閿欒鐮?| 閿欒淇℃伅锛堝叧閿墖娈碉級 | 鍘熷洜 |
|---|------|--------|---------------------|------|
| 1 | Chocolatey 瀹夎鍚?| 鈥?| `winget : 鏃犳硶灏?winget"璇嗗埆涓?cmdlet` | 绯荤粺鏈 App Installer / WinGet |
| 2 | Chocolatey 瀹夎鍚?| 鈥?| `where.exe wt` 鎵句笉鍒板懡浠?| App Execution Alias 鏈敓鎴?|
| 3 | 閲嶆敞鍐?AppX | `0x80073CF3` | 姝ょ▼搴忓寘渚濊禆浜庝竴涓壘涓嶅埌鐨勬鏋躲€俙Microsoft.UI.Xaml.2.8` (8.2305.5001.0) | Chocolatey 鍖呬笉甯︽鏋朵緷璧?|
| 4 | 鍚姩 `wt.exe` | 鈥?| `鎷掔粷璁块棶` | WindowsApps 鐩綍 ACL锛屾櫘閫氱鐞嗗憳鏃犳硶鐩存帴 EXE |
| 5 | GitHub 鐩磋繛涓嬭浇 | 鈥?| 6.6 MB 瓒呮椂涓柇 | 缃戠粶涓嶇ǔ锛屾枃浠跺疄闄?21.3 MB |
| 6 | GitHub S3 鐩磋繛 | `401` | 鏈巿鏉?| release asset 璧扮鍚?URL锛屽尶鍚嶈闂彈闄?|
| 7 | `release-assets.githubusercontent.com` 浠ｇ悊 | `618` | `jwt: jwt-not-provided` | 璇ヤ唬鐞嗛渶瑕?JWT token |
| 8 | 鎹熷潖 MSIX bundle 瀹夎 | `0x80073CF0` / `0x8007000D` | 鍦ㄤ綅浜?Microsoft.WindowsTerminal.msixbundle 涓墦寮€绋嬪簭鍖呭け璐?| 鏂囦欢涓嬭浇涓嶅畬鏁达紙ZIP central directory 涓㈠け锛?|
| 9 | 闈炰氦浜掔幆澧冨惎鍔?| 鈥?| `鎵句笉鍒伴€傜敤鐨勫簲鐢ㄨ瘉涔 | AppX GUI 搴旂敤蹇呴』鍦ㄤ氦浜掑紡鐢ㄦ埛浼氳瘽涓繍琛?|
| 10 | `Remove-AppxPackage` | `0x80070002` | 绯荤粺鎵句笉鍒版寚瀹氱殑鏂囦欢 | AppX 宸?staged 鍒?SYSTEM 浣嗘湰浼氳瘽鏃犳潈鍗歌浇 |

---

## 鍏€佽俯鍧戞暀璁?/ 缁忛獙

1. **Chocolatey 瀹夎鐨?MSIX 鍖呬笉鍖呭惈 Framework Package 渚濊禆**銆傞渶瑕佸厛瑁?Windows App SDK 瀵瑰簲鐗堟湰鐨?WinUI 妗嗘灦銆?2. **Windows 10 绂荤嚎/鏃?Store 鐜瑁?Windows Terminal 鐨勬渶浣冲Э鍔?*锛?   - 涓嬭浇 GitHub releases 鐨?`*_Windows10_PreinstallKit.zip`锛堝凡鎹嗙粦 `Microsoft.UI.Xaml.*` 绛夋鏋讹級
   - 鍏?`Add-AppxPackage` 瀹夎 x64 鐨?`Microsoft.UI.Xaml.2.8.appx`
   - 鍐?`Add-AppxPackage` 瀹夎 `.msixbundle`
3. **GitHub release 涓嬭浇涓嶇ǔ**锛歚gh-proxy.org` 鍓嶇紑浠ｇ悊鏄棤 token 鐨勫彲鐢ㄦ柟妗堬細
   ```
   https://gh-proxy.org/https://github.com/<user>/<repo>/releases/download/<tag>/<file>
   ```
4. **蹇呴』鐢?SHA256 鏍￠獙涓嬭浇鐨?PreinstallKit**锛岄伩鍏嶄笅鍒版崯鍧忓寘銆傛崯鍧忓寘鎶?`0x8007000D` 閿欒闅惧畾浣嶃€?5. **涓嶈灏濊瘯鐩存帴鎵ц** `C:\Program Files\WindowsApps\...\wt.exe`锛屼細琚?ACL 鎷掔粷銆傜粺涓€閫氳繃 App Execution Alias `wt.exe` 鍚姩銆?
---

## 涓冦€佸叧閿懡浠ら€熸煡

```powershell
# 楠岃瘉鍖?Get-AppxPackage -Name Microsoft.WindowsTerminal -AllUsers
Get-AppxPackage -Name "Microsoft.UI.Xaml*" -AllUsers

# 楠岃瘉 wt 鍛戒护
Get-Command wt
Test-Path "$env:LOCALAPPDATA\Microsoft\WindowsApps\wt.exe"

# 鍗歌浇锛堥渶瑕佷氦浜掑紡绠＄悊鍛樹細璇濓級
Get-AppxPackage Microsoft.WindowsTerminal -AllUsers | Remove-AppxPackage -AllUsers
choco uninstall microsoft-windows-terminal -y
```

---

## 鍏€佸弬鑰冮摼鎺?
- Windows Terminal GitHub: https://github.com/microsoft/terminal
- Release v1.24.11911.0: https://github.com/microsoft/terminal/releases/tag/v1.24.11911.0
- PreinstallKit 璧勪骇锛歚Microsoft.WindowsTerminal_1.24.11911.0_8wekyb3d8bbwe.msixbundle_Windows10_PreinstallKit.zip`
- Windows App SDK: https://learn.microsoft.com/windows/apps/windows-app-sdk/
- gh-proxy 浠ｇ悊: https://gh-proxy.org

---

**鏂囨。鍒涘缓鏃堕棿**锛氭湰娆″畨瑁呬細璇?**鏈€缁堢姸鎬?*锛氣渽 Windows Terminal 1.24.11911.0 + UI.Xaml.2.8 妗嗘灦宸叉垚鍔熷畨瑁呭苟楠岃瘉

# 鎭舵剰杞欢娓呴櫎璁板綍

---

## 涓€銆佸彂鐜扮殑鎭舵剰杞欢

| 椤圭洰 | 璇︽儏 |
|------|------|
| 鐥呮瘨鍚嶇О | **"DirectX.DLL淇宸ュ叿"** (SmartDLLRepairOfficial) |
| 鎰熸煋鏃堕棿 | 2026/8/10 12:10:26 |
| 瀹夎璺緞 | `C:\Program Files (x86)\DLLRepairOfficial\` |
| 妗岄潰蹇嵎鏂瑰紡 | `DirectX淇宸ュ叿.lnk` 鈫?`DllRepair.exe` |
| 鎭舵剰缁勪欢 | `dhp.exe`, `dsbar.exe`, `rps.exe`, `XDLogin.dll`, `WebView.dll`, `CefApp.exe` |
| 璁″垝浠诲姟 | `SmartDLLRepairOfficialTask`, `DirectXDatabaseUpdater` |
| 绫诲瀷 | 骞垮憡杞欢 / 娴忚鍣ㄥ姭鎸?|

## 浜屻€佹竻闄ゆ楠?
### 1. 鍋滄鍙枒杩涚▼
```powershell
Get-Process | Where-Object { $_.ProcessName -match "dhp|dsbar|rps|CefApp|DllRepair" } | Stop-Process -Force
```

### 2. 鎵ц鍗歌浇绋嬪簭
```powershell
& "C:\Program Files (x86)\DLLRepairOfficial\Uninstall.exe" --silent
```

### 3. 鍒犻櫎璁″垝浠诲姟
```powershell
Unregister-ScheduledTask -TaskName "SmartDLLRepairOfficialTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "DirectXDatabaseUpdater" -Confirm:$false
```

### 4. 娓呯悊娈嬬暀鏂囦欢
```powershell
Remove-Item "C:\Program Files (x86)\DLLRepairOfficial" -Recurse -Force
Remove-Item "C:\ProgramData\SmartDLLRepairOfficial" -Recurse -Force
Remove-Item "C:\ProgramData\DirectXDatabaseUpdater" -Recurse -Force
Remove-Item "C:\Users\Administrator\Desktop\DirectX*.lnk" -Force
```

### 5. 娓呯悊娉ㄥ唽琛ㄥ惎鍔ㄩ」
```powershell
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" |
    Get-Member -MemberType NoteProperty | ForEach-Object {
        $value = (Get-ItemProperty -Path $regPath).$($_.Name)
        if ($value -match "DLLRepair|DirectX|dhp|dsbar|rps") {
            Remove-ItemProperty -Path $regPath -Name $_.Name -Force
        }
    }
```

## 涓夈€佹渶缁堟鏌ョ粨鏋?
| 妫€鏌ラ」 | 鐘舵€?|
|--------|------|
| 鍙枒鐩綍 | 鉁?宸插垹闄?|
| 妗岄潰蹇嵎鏂瑰紡 | 鉁?宸插垹闄?|
| 璁″垝浠诲姟 | 鉁?宸插垹闄?|
| 鍙枒杩涚▼ | 鉁?鏃犳畫鐣?|
| 娉ㄥ唽琛ㄥ惎鍔ㄩ」 | 鉁?宸叉竻鐞?|

---

## 鍥涖€?60瀹夊叏鍗＋ + 鐖卞鑹?褰诲簳娓呴櫎璁板綍锛?026-09-17锛?
### 1. 鍙戠幇鐨勫▉鑳?
| 椤圭洰 | 璇︽儏 |
|------|------|
| **360瀹夊叏鍗＋** | `C:\Program Files (x86)\360\360Safe\` |
| 鐖卞鑹?| `C:\Program Files\IQIYI Video\` |
| 360鍐呮牳椹卞姩 | 8涓紙360netmon, 360Box64, 360Camera, 360AntiHacker, 360Hvm, 360AntiHijack, 360AntiSteal, 360FsFlt锛?|
| 360杩涚▼ | `ZhuDongFangYu.exe`锛堜富鍔ㄩ槻寰★級銆乣safesvr.exe`锛堝畨鍏ㄦ湇鍔★級 |
| 鐖卞鑹鸿繘绋?| `QiyiService.exe`銆乣QyKernel.exe` |
| 鐖卞鑹烘湇鍔?| `QiyiService`锛圧unning锛?|
| 鐖卞鑹鸿鍒掍换鍔?| `SmartDLLRepairOfficialTask`銆乣DirectXDatabaseUpdater` |

### 2. 娓呴櫎杩囩▼

#### 绗竴杞細姝ｅ父妯″紡涓嬪皾璇曪紙澶辫触锛?
```powershell
# 鍋滄鐖卞鑹烘湇鍔?Stop-Service -Name "QiyiService" -Force

# 鍋滄鐖卞鑹鸿繘绋?Get-Process -Name "QiyiService","QyKernel" | Stop-Process -Force

# 鐖卞鑹虹洰褰曞垹闄ゆ垚鍔?Remove-Item "C:\Program Files\IQIYI Video" -Recurse -Force

# 360杩涚▼鍋滄锛堜絾琚唴鏍搁┍鍔ㄤ繚鎶わ紝鏃犳硶鐪熸鍋滄锛?Stop-Process -Name "ZhuDongFangYu" -Force

# 360鍐呮牳椹卞姩绂佺敤
sc.exe config 360netmon start= disabled
sc.exe stop 360netmon
# ... 瀵?涓┍鍔ㄩ噸澶嶆搷浣?
# 360椹卞姩鏂囦欢鍒犻櫎锛堟垚鍔燂級
Remove-Item "C:\Windows\System32\Drivers\360*.sys" -Force
Remove-Item "C:\Windows\System32\DRIVERS\360*.sys" -Force

# 360绋嬪簭鐩綍鍒犻櫎锛堝け璐?- 琚攣瀹氾級
Remove-Item "C:\Program Files (x86)\360" -Recurse -Force
# 鎶ラ敊锛氳闂鎷掔粷
```

**闂**锛?60鏈夊唴鏍哥骇鑷垜淇濇姢锛屾甯告ā寮忎笅鏃犳硶鍒犻櫎绋嬪簭鐩綍銆?
#### 绗簩杞細瀹夊叏妯″紡涓嬪皾璇曪紙閮ㄥ垎鎴愬姛锛?
```powershell
# 杩涘叆瀹夊叏妯″紡
msconfig 鈫?寮曞 鈫?瀹夊叏寮曞(缃戠粶) 鈫?閲嶅惎

# 瀹夊叏妯″紡涓嬭繍琛屽垹闄よ剼鏈?taskkill /F /IM "ZhuDongFangYu.exe"
taskkill /F /IM "safesvr.exe"
rmdir /s /q "C:\Program Files (x86)\360"
```

**闂**锛?涓猄hell鎵╁睍DLL琚玏indows璧勬簮绠＄悊鍣ㄥ姞杞斤紝鏃犳硶鍒犻櫎锛?- `360base64.dll`
- `360UDiskGuard64.dll`
- `SoftMgrExt64.dll`
- `shell360ext64.dll`

#### 绗笁杞細MoveFileEx API 寮哄埗鍒犻櫎锛堟垚鍔燂級

```powershell
# 浣跨敤Windows鍐呮牳API瀹夋帓閲嶅惎鍒犻櫎
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

# 瀹夋帓鍒犻櫎4涓攣瀹氱殑DLL
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\360base64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\safemon\360UDiskGuard64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\SoftMgr\SoftMgrExt64.dll")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe\Utils\shell360ext64.dll")

# 瀹夋帓鍒犻櫎鏁翠釜鐩綍
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360\360Safe")
[FileMover]::DeleteOnReboot("C:\Program Files (x86)\360")
```

**鍘熺悊**锛歚MoveFileEx` + `MOVEFILE_DELAY_UNTIL_REBOOT` 鏍囧織璁￤indows鍐呮牳鍦ㄩ噸鍚椂銆佷换浣曠▼搴忓姞杞藉墠鍒犻櫎鏂囦欢銆?
#### 绗洓杞細娓呯悊鏈€鍚庢畫鐣?
```powershell
# 鍒犻櫎AppData涓嬬殑360鐩綍
Remove-Item "C:\Users\Administrator\AppData\Roaming\360safe" -Recurse -Force

# 鍒犻櫎娉ㄥ唽琛ㄥ惎鍔ㄩ」
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "360huabao" -Force
```

### 3. 鏈€缁堟鏌ョ粨鏋?
| 妫€鏌ラ」 | 鐘舵€?|
|--------|------|
| 杩涚▼ | 鉁?鏃?60/鐖卞鑹鸿繘绋?|
| 鍐呮牳椹卞姩 | 鉁?鏃?60椹卞姩 |
| 椹卞姩鏂囦欢 | 鉁?鏃?60 .sys鏂囦欢 |
| 绋嬪簭鐩綍 | 鉁?`C:\Program Files (x86)\360` 宸插垹闄?|
| ProgramData | 鉁?鏃?60娈嬬暀 |
| AppData | 鉁?鏃?60娈嬬暀 |
| 娉ㄥ唽琛ㄥ惎鍔ㄩ」 | 鉁?鏃?60鍚姩椤?|
| 璁″垝浠诲姟 | 鉁?鏃?60璁″垝浠诲姟 |
| 鐖卞鑹虹洰褰?| 鉁?宸插垹闄?|
| 鐖卞鑹烘湇鍔?| 鉁?宸插仠姝㈠苟鍒犻櫎 |

### 4. 韪╁潙鏁欒

| # | 闂 | 瑙ｅ喅鏂规 |
|---|------|----------|
| 1 | 360鏈夊唴鏍哥骇鑷垜淇濇姢锛屾甯告ā寮忔棤娉曞仠姝㈣繘绋?| 蹇呴』杩涘叆瀹夊叏妯″紡 |
| 2 | 瀹夊叏妯″紡涓嬩粛鏃犳硶鍒犻櫎Shell鎵╁睍DLL | 浣跨敤 `MoveFileEx` API 瀹夋帓閲嶅惎鍒犻櫎 |
| 3 | 鏅€?`Remove-Item` 鏃犳硶鍒犻櫎琚攣瀹氱殑鏂囦欢 | 浣跨敤 `MOVEFILE_DELAY_UNTIL_REBOOT` 鏍囧織 |
| 4 | 360娉ㄥ唽琛ㄥ惎鍔ㄩ」 `360huabao` 瀹规槗閬楁紡 | 娓呴櫎鍚庨渶妫€鏌ユ敞鍐岃〃 `Run` 椤?|
| 5 | AppData涓嬬殑360鐩綍瀹规槗閬楁紡 | 娓呴櫎鍚庨渶妫€鏌?`AppData\Roaming\360*` |

### 5. 褰诲簳娓呴櫎360鐨勬爣鍑嗘祦绋?
```
1. 杩涘叆瀹夊叏妯″紡 (msconfig 鈫?瀹夊叏寮曞 鈫?缃戠粶)
2. 杩愯 taskkill /F 缁堟鎵€鏈?60杩涚▼
3. 绂佺敤鎵€鏈?60鏈嶅姟 (sc config start= disabled)
4. 鍒犻櫎360绋嬪簭鐩綍 (rmdir /s /q)
5. 鍒犻櫎360椹卞姩鏂囦欢 (del /f /q *.sys)
6. 娓呯悊娉ㄥ唽琛?(reg delete)
7. 閲嶅惎鍥炴甯告ā寮?8. 鐢?MoveFileEx API 鍒犻櫎琚攣瀹氱殑DLL
9. 鍐嶆閲嶅惎瀹屾垚鍒犻櫎
10. 娓呯悊AppData鍜屾敞鍐岃〃鍚姩椤?```

---

# Windows Terminal 浣跨敤鎸囧崡

> 瀹夎瀹屼箣鍚庢€庝箞鐢ㄢ€斺€斿父鐢ㄥ揩鎹烽敭銆侀厤缃€佽皟浼樸€佽俯鍧戙€?
---

## 涔濄€佸揩閫熶笂鎵?
### 9.1 鍚姩鏂瑰紡

| 鏂瑰紡 | 鎿嶄綔 |
|------|------|
| 寮€濮嬭彍鍗?| 鎼滅储銆學indows Terminal銆?|
| 杩愯 | `Win + R` 鈫?杈撳叆 `wt` 鍥炶溅 |
| 鍛戒护琛?| 鍦ㄤ换鎰忕粓绔墽琛?`wt.exe` |
| 鎸囧畾 profile 鍚姩 | `wt -p "Ubuntu"` |
| 浠ョ鐞嗗憳韬唤鍚姩 | 寮€濮嬭彍鍗曞彸閿?鈫?`鏇村` 鈫?`浠ョ鐞嗗憳韬唤杩愯` |

### 9.2 璁剧疆涓洪粯璁ょ粓绔紙寮虹儓鎺ㄨ崘锛?
Windows Terminal 1.16+ 鏀寔鎺ョ绯荤粺鐨勯粯璁ょ粓绔細

1. 鎵撳紑 Windows Terminal 鈫?`Ctrl + ,` 鎵撳紑璁剧疆
2. 宸︿笅瑙?鈫?`鍚姩` 鈫?`榛樿閰嶇疆鏂囦欢`锛堥€夋渶甯哥敤鐨?shell锛?3. 鍏抽敭姝ラ锛歚璁剧疆` 鈫?`闅愮鍜屽畨鍏╜ 鈫?`寮€鍙戣€呮ā寮廯锛圵in10 鏃х増鏄?`寮€鍙戣€呴€夐」`锛夆啋 **寮€鍚€岀粓绔€嶄腑鐨勫紑鍙戣€呮ā寮?*
4. 鍐嶅埌 `璁剧疆` 鈫?`绯荤粺` 鈫?`寮€鍙戣€呴€夐」` 鈫?`缁堢` 鈫?**鎶婇粯璁ょ粓绔簲鐢ㄦ敼涓恒€學indows Terminal銆?*

涔嬪悗锛?- `Win + R` 鈫?`cmd` / `powershell` 鈫?閮藉紑鍦?Windows Terminal 閲?- VS Code銆佹枃浠惰祫婧愮鐞嗗櫒鍦板潃鏍忚緭鍏?`cmd` 鈫?鍚屾牱杩?WT

> 鈿狅笍 Win10 2004 杈冭€侊紝銆屽紑鍙戣€呮ā寮忋€嶅紑鍏宠矾寰勫彲鑳界暐鏈夊樊寮傦紱鎵句笉鍒板氨鐢?`Ctrl + ,` 鈫?璁剧疆 UI 閲屾悳銆岄粯璁ょ粓绔€嶃€?
---

## 鍗併€侀厤缃枃浠?`settings.json`

### 10.1 鎵撳紑閰嶇疆鏂囦欢

- 蹇嵎閿細`Ctrl + Shift + ,`
- 鎴?UI 璁剧疆閲岀偣宸︿笂瑙?`鈱榒 鈫?`鎵撳紑 JSON 鏂囦欢`

鏂囦欢浣嶇疆锛?
```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

### 10.2 鏂囦欢缁撴瀯姒傝

```jsonc
{
  "$schema": "https://aka.ms/terminal-profiles-schema",
  "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",  // 榛樿 profile GUID
  "profiles": {
    "defaults": {              // 鎵€鏈?profile 鐨勯粯璁ゅ€?      "fontFace": "Cascadia Code",
      "fontSize": 11,
      "padding": "8, 8, 8, 8",
      "useAcrylic": true,
      "acrylicOpacity": 0.85,
      "colorScheme": "Tango Dark"
    },
    "list": [
      { "guid": "{61c54bbd-...}", "name": "Windows PowerShell", "commandline": "powershell.exe" },
      { "guid": "{0caa0dad-...}", "name": "鍛戒护鎻愮ず绗?,       "commandline": "cmd.exe" },
      { "guid": "{2c4de342-...}", "name": "Ubuntu",            "commandline": "wsl.exe -d Ubuntu" }
    ]
  },
  "schemes": [ /* 閰嶈壊鏂规 */ ],
  "keybindings": [ /* 蹇嵎閿?*/ ],
  "actions": []
}
```

### 10.3 鎺ㄨ崘閰嶇疆鐗囨锛堢洿鎺ュ鍒剁矘璐寸敤锛?
#### 1) PowerShell 缇庡寲 + 鑷姩琛ュ叏鍥炬爣

```jsonc
"profiles": {
  "defaults": {
    "fontFace": "Cascadia Code NF",   // 闇€瑕佸厛瑁?Nerd Font
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

#### 2) Git Bash 鍔犲叆 profile锛堝鏋滆浜?Git for Windows锛?
```jsonc
{
  "guid": "{b1e5b3a4-1234-5678-9abc-def012345678}",
  "name": "Git Bash",
  "commandline": "C:\\Program Files\\Git\\bin\\bash.exe --login -i",
  "icon": "C:\\Program Files\\Git\\mingw64\\share\\git\\git-for-windows.ico"
}
```

#### 3) SSH 杩滅▼鐧诲綍 profile

```jsonc
{
  "guid": "{11111111-2222-3333-4444-555555555555}",
  "name": "My-Server",
  "commandline": "ssh user@192.0.2.100",
  "icon": "ms-appx:///ProfileIcons/{0caa0dad-35a3-2a25-56bc-969a52f2e5cf}.png"
}
```

#### 4) 閰嶈壊鏂规锛堟坊鍔犲埌 `schemes` 鏁扮粍锛?
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

## 鍗佷竴銆佸繀澶囧揩鎹烽敭

### 11.1 鏍囩椤?
| 蹇嵎閿?| 鍔熻兘 |
|--------|------|
| `Ctrl + Shift + T` | 鏂板缓鏍囩椤碉紙娌跨敤榛樿 profile锛?|
| `Ctrl + Shift + N` | 鏂板缓绐楀彛 |
| `Ctrl + T` | 鎵撳紑鍛戒护闈㈡澘锛堟悳绱㈡墍鏈夊懡浠わ級 |
| `Ctrl + Tab` / `Ctrl + Shift + Tab` | 鍒囨崲涓嬩竴涓?/ 涓婁竴涓爣绛?|
| `Ctrl + 鏁板瓧 1-9` | 鐩存帴璺冲埌绗?N 涓爣绛?|
| `Alt + Shift + 鈫?鈫抈 | 绉诲姩褰撳墠鏍囩浣嶇疆 |
| `Ctrl + Shift + W` | 鍏抽棴褰撳墠鏍囩 |

### 11.2 绐楁牸锛堝垎灞忥級

| 蹇嵎閿?| 鍔熻兘 |
|--------|------|
| `Alt + Shift + D` | 澶嶅埗褰撳墠绐楁牸锛堝乏鍙冲垎灞忥級 |
| `Alt + Shift + +` / `Alt + Shift + -` | 涓婁笅 / 宸﹀彸鍒嗗睆 |
| `Alt + 鈫?鈫?鈫?鈫揱 | 绐楁牸闂村垏鎹㈢劍鐐?|
| `Ctrl + Shift + 鈫?鈫抈 | 璋冩暣绐楁牸瀹藉害 |
| `Ctrl + Shift + 鈫?鈫揱 | 璋冩暣绐楁牸楂樺害 |

### 11.3 鏂囨湰鎿嶄綔

| 蹇嵎閿?| 鍔熻兘 |
|--------|------|
| `Ctrl + Shift + C` / `Ctrl + Insert` | 澶嶅埗 |
| `Ctrl + Shift + V` / `Shift + Insert` | 绮樿创 |
| `Ctrl + ,` | 鎵撳紑璁剧疆 UI |
| `Ctrl + Shift + ,` | 鎵撳紑 `settings.json` |
| `Ctrl + Shift + F` | 鏌ユ壘锛堟敮鎸佹鍒欙級 |
| `Ctrl + 婊氳疆` / `Ctrl + +/-/0` | 缂╂斁瀛椾綋锛坄0` 閲嶇疆锛?|

### 11.4 鍛戒护闈㈡澘锛坄Ctrl + T`锛夊父鐢ㄥ懡浠?
```
settings                  # 鎵撳紑璁剧疆 UI
settings json             # 鎵撳紑 settings.json
reload config             # 閲嶆柊鍔犺浇閰嶇疆锛堜繚瀛樺悗鏃犻渶閲嶅惎锛?toggle always on top      # 绐楀彛缃《
font size: 14             # 涓存椂鏀瑰瓧鍙?color scheme: OneHalfDark # 涓存椂鍒囨崲閰嶈壊
close pane                # 鍏抽棴褰撳墠绐楁牸
```

---

## 鍗佷簩銆佽繘闃剁帺娉?
### 12.1 鐢?quake 妯″紡锛堢被浼?Guake / yakuake锛?
Windows Terminal 娌℃湁鍘熺敓 quake 妯″紡锛屼絾鍙互鐢?AutoHotKey锛?
```ahk
; Win + ` 鍙敜/闅愯棌 Windows Terminal
#`::
    DetectHiddenWindows, On
    IfWinExist ahk_exe WindowsTerminal.exe
        WinHide, ahk_exe WindowsTerminal.exe
    else {
        Run, wt.exe
        WinWait, ahk_exe WindowsTerminal.exe
        WinShow, ahk_exe WindowsTerminal.exe
        ; 鍏ㄥ睆缃《
        WinSet, Style, ^0x80000, ahk_exe WindowsTerminal.exe
    }
return
```

### 12.2 涓€閿?SSH 鍒板父鐢ㄦ湇鍔″櫒

鎶婂鏉″父鐢?SSH 鍔犲埌 profile.list 閲岋紝鍐嶈涓惎鍔ㄥ弬鏁帮細

```powershell
# 鍚姩 WT 骞舵墦寮€鍒版寚瀹氭湇鍔″櫒鐨勬柊鏍囩
wt -p "My-Server"
```

### 12.3 鍛戒护琛屽弬鏁伴€熸煡

```powershell
wt [options] [command ; command...]

# 甯哥敤锛?wt -p "Ubuntu"                         # 鐢ㄦ寚瀹?profile
wt --maximized                         # 鏈€澶у寲鍚姩
wt --fullscreen                        # 鍏ㄥ睆
wt --pos 100,100 --size 1200,800       # 鎸囧畾浣嶇疆鍜屽ぇ灏?wt new-tab -p "PowerShell" ; split-pane -p "Ubuntu" -V   # 鎵撳紑鏍囩 + 绔栫洿鍒嗗睆
wt -d "C:\Users\me\project"            # 鎸囧畾鍚姩鐩綍
```

### 12.4 閰嶅悎 Starship / oh-my-posh 缇庡寲 Prompt

PowerShell 7 鎺ㄨ崘 **Starship**锛堣法骞冲彴銆佸揩锛夛細

```powershell
# 瀹夎
winget install --id Starship.Starship

# 缂栬緫 $PROFILE
notepad $PROFILE
# 娣诲姞锛?Invoke-Expression (&starship init powershell)
```

鎴栧湪 PowerShell 5 鐢?**oh-my-posh**锛?
```powershell
Install-Module oh-my-posh -Scope CurrentUser
notepad $PROFILE
# 娣诲姞锛?Import-Module oh-my-posh
Set-PoshPrompt -Theme Paradox
```

### 12.5 Nerd Font 瀛椾綋锛堝浘鏍囧繀澶囷級

鍥炬爣瀛椾綋 + Nerd Font 鎵╁睍 = 鍚勭鏂囦欢/宸ュ叿鍥炬爣锛?
1. 涓嬭浇 [Cascadia Code Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases)
2. 瑙ｅ帇瀹夎鎵€鏈?`.ttf`
3. `settings.json` 鈫?`fontFace` 鏀逛负 `CascadiaCode Nerd Font`锛堟敞鎰忕┖鏍硷級

---

## 鍗佷笁銆佸父瑙侀棶棰橈紙浣跨敤闃舵锛?
### Q1锛氱矘璐村ぇ閲忓唴瀹瑰崱椤?/ 涔辩爜
- 鍏抽棴銆宐racketed paste mode銆嶏細鍦?profile 閲屽姞 `"experimental.retroTerminalEffect": false`
- 鎴栦复鏃?`Ctrl + Shift + V` 鏀逛负 `Ctrl + V` 绯荤粺绮樿创

### Q2锛歅owerShell 5 棰滆壊涓嶄寒 / 鏄剧ず鑰佸彜钁ｉ厤鑹?- 鐢?PowerShell 7 浠ｆ浛锛歚winget install Microsoft.PowerShell`
- 鎴栧湪 PowerShell 5 鍔?`$PROFILE`锛?  ```powershell
  Set-PSReadLineOption -Colors @{ Command = "Yellow"; Parameter = "Cyan"; Operator = "White" }
  ```

### Q3锛歐SL 榛樿杩?cmd 涓嶈繘 bash
- 淇敼 `defaultProfile` 涓?WSL 鐨?GUID
- 鎴栧湪 WSL profile 閲?`"commandline": "wsl.exe -d Ubuntu"`

### Q4锛氭兂璺ㄨ澶囧悓姝ラ厤缃?- 鎶?`settings.json` 鐢ㄧ鍙烽摼鎺ユ寚鍚?OneDrive / 鍧氭灉浜戠洰褰?- 鎴栫敤 `scoop import / export` 绠＄悊

### Q5锛氬浣曟墦寮€鏃х増 cmd 绐楀彛锛堜笉閫氳繃 WT锛?- `Win + R` 鈫?`cmd` 鈫?濡傛灉榛樿缁堢宸叉敼涓?WT锛屼細寮哄埗鍦?WT 閲屽紑
- 鎯冲己鍒跺洖鑰佺獥鍙ｏ細涓存椂鎶娿€岄粯璁ょ粓绔€嶆敼鍥?`Windows 鎺у埗鍙颁富鏈篳

### Q6锛氫腑鏂囨樉绀轰负鏂规 / 闂磋窛涓嶅
- 瀹夎 `Cascadia Code NF` 鎴栧叾瀹?Nerd Font
- profile 閲?`"fontFace": "Cascadia Code NF"`銆乣"fontSize": 12`

### Q7锛氭爣绛炬爣棰樻樉绀?`pwsh.exe` 鑰屼笉鏄綋鍓嶇洰褰?- PowerShell 7锛氳嚜鍔ㄥ氨鏈?- PowerShell 5锛氱紪杈?`$PROFILE` 鍔狅細
  ```powershell
  function prompt { "$pwd\$> " }
  ```

### Q8锛堝叧閿級锛歚wt` / `wt.exe` 鎶?"绯荤粺鏃犳硶鎵ц鎸囧畾鐨勭▼搴?
**鐥囩姸**锛?```cmd
C:\> wt
绯荤粺鏃犳硶鎵ц鎸囧畾鐨勭▼搴忋€?
C:\> wt.exe
绯荤粺鏃犳硶鎵ц鎸囧畾鐨勭▼搴忋€?```
PowerShell 閲岋細
```powershell
PS> Start-Process wt.exe
鎵句笉鍒伴€傜敤鐨勫簲鐢ㄨ瘉涔?```

**鍘熷洜**锛氬綋鍓?Windows 浼氳瘽鏄?*闈炰氦浜掑紡 / 宸叉柇寮€**锛坄query session` 鏄剧ず `鏂紑`锛夈€?AppX GUI 搴旂敤蹇呴』缁?Shell 閫氳繃 `ShellExecute` 婵€娲伙紝鐩存帴 `CreateProcess` 鍦ㄦ棤妗岄潰鐜涓嬩細澶辫触銆?
**瑙ｅ喅鏂规**锛?
1. **鏈€绠€鍗?鈥?鐢?`start`**锛?   ```cmd
   start wt
   ```
   `start` 璧?Windows Shell 婵€娲伙紝鑳借烦杩?AppX 鐩存帴璋冪敤鐨勯檺鍒躲€?
2. **鐢?AUMID**锛?   ```cmd
   explorer shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
   ```
   鎴?PowerShell锛?   ```powershell
   Start-Process "shell:AppsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App"
   ```

3. **鏈€绋?鈥?閲嶆柊鐧诲綍浜や簰寮忔闈?*锛?   - 鐢?RDP / 鎺у埗鍙扮墿鐞嗙櫥褰曞悗鍐嶆鎵ц `wt`
   - 閲嶅惎鐢佃剳杩涘叆姝ｅ父妗岄潰 session 涔熻
   - 楠岃瘉褰撳墠鏄惁鏂紑锛?     ```cmd
     query session
     ```
     鑻ヨ緭鍑哄舰濡?`console Administrator 1 鏂紑`锛屽氨鏄繖涓棶棰樸€?
4. **鑷姩鍖栧満鏅笅**锛圕I / 杩滅▼鎵ц锛夛細鎶?`wt.exe` 鐨勮皟鐢ㄥ叏閮ㄦ敼鎴?`cmd /c "start wt"` 鎴栬皟鐢?AUMID銆?
---

## 鍗佸洓銆佹€ц兘涓庤皟璇?
### 14.1 鍚姩鎱?/ 鍗￠】

`settings.json` 璋冩暣锛?
```jsonc
{
  "profiles": {
    "defaults": {
      "useAcrylic": false,        // 鍏虫帀浜氬厠鍔涜儗鏅彲鐪?GPU
      "experimental.retroTerminalEffect": false,
      "antialiasingMode": "grayscale"  // 鐏板害鎶楅敮榻挎瘮 ClearType 蹇?    }
  }
}
```

### 14.2 璋冭瘯鏃ュ織

```powershell
# 鍚姩鏃惰緭鍑烘棩蹇楀埌鏂囦欢
wt --logging "C:\Users\$env:USERNAME\Desktop\wt.log"
```

鎴栧湪 `settings.json`锛?
```jsonc
{ "debugFeatures": { "forceFullRepaint": true } }
```

### 14.3 閲嶇疆鎵€鏈夐厤缃?
```powershell
# 鍒犳帀 LocalState 鍗冲彲锛堜笉褰卞搷 AppX 瀹夎锛?Remove-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" -Recurse -Force
# 涓嬫鍚姩浼氳嚜鍔ㄩ噸寤洪粯璁?settings.json
```

---

## 鍗佷簲銆佹帹鑽愮敓鎬侊紙鎸夐渶瀹夎锛?
| 宸ュ叿 | 浣滅敤 | 瀹夎 |
|------|------|------|
| PowerShell 7 | 鐜颁唬 PowerShell 鏇夸唬 5.1 | `winget install Microsoft.PowerShell` |
| Windows Terminal 鏈€鏂伴瑙堢増 | 鎶㈠厛浣撻獙鏂扮壒鎬?| GitHub releases 鈫?閫夋嫨 `Pre` 鏍囩 |
| Starship | 璺?shell 鐨?prompt 涓婚 | `winget install Starship.Starship` |
| Nerd Font | 鍥炬爣瀛椾綋 | [GitHub releases](https://github.com/ryanoasis/nerd-fonts/releases) |
| WSL2 | Linux 瀛愮郴缁?| `wsl --install` |
| eza / lsd | 鏇夸唬 `ls` 鐨勭幇浠ｅ伐鍏?| `scoop install eza` |
| ripgrep | 瓒呭揩 grep | `scoop install ripgrep` |
| fd | 鏇夸唬 `find` | `scoop install fd` |
| bat | 鏇夸唬 `cat`锛堝甫楂樹寒锛?| `scoop install bat` |

---

## 鍗佸叚銆佷竴鍙ヨ瘽鎬荤粨

- **Win + R 鈫?`wt` 鍥炶溅** = 90% 鐨勪娇鐢ㄥ満鏅?- **`Ctrl + T` 鍛戒护闈㈡澘** = 鎵惧姛鑳芥渶蹇?- **`Ctrl + ,` 璁剧疆 UI** = 鏂版墜鍙嬪ソ
- **`Ctrl + Shift + ,` JSON** = 楂樼骇鐜╁
- **`Ctrl + Shift + T` 鏂版爣绛?* + **`Alt + Shift + D` 鍒嗗睆** = 鏃ュ父鎻愭晥

---

# Git 浠ｇ悊绠＄悊鑴氭湰

> 鍦?Windows Terminal 涓娇鐢?PowerShell 涓€閿鐞?Git 鐨?SOCKS5 浠ｇ悊銆?> 鑴氭湰鏂囦欢: D:\Windows_Terminal\git-proxy.ps1

---

## 涓€銆佷负浠€涔堥渶瑕佽繖涓剼鏈?
- 鍥藉唴璁块棶 GitHub / GitLab 缁忓父鍗￠】鎴栬秴鏃?- 璁剧疆鐜鍙橀噺 HTTPS_PROXY 浼氬奖鍝嶆墍鏈夊簲鐢?绮掑害澶矖
- 鐩存帴鏀?git config 姣忔閮借鍐欎竴闀夸覆鍛戒护
- 杩欎釜鑴氭湰**鍙敼 git 鍏ㄥ眬閰嶇疆**,涓嶅奖鍝嶇郴缁熷叾浠栧簲鐢?
---

## 浜屻€佹敮鎸佺殑鍗忚

浠呮敮鎸?**SOCKS5**(鍏朵粬浠ｇ悊濡?HTTP/HTTPS 浠ｇ悊璇锋敼 git-proxy.ps1 涓殑鍗忚鍚?銆?
---

## 涓夈€佺敤娉曢€熸煡

### 1. 鏌ョ湅甯姪

`powershell
.\git-proxy.ps1 -Help
`

### 2. 璁剧疆浠ｇ悊(绔嬪嵆鐢熸晥)

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
`

鍙傛暟:
- -h <IP> 浠ｇ悊鏈嶅姟鍣ㄥ湴鍧€(IP 鎴栧煙鍚?
- -p <绔彛> 浠ｇ悊绔彛
- -s 搴旂敤璁剧疆

**鏁堟灉**:寰€ ~/.gitconfig 鍐欏叆:
`
http.proxy  = socks5://127.0.0.1:1080
https.proxy = socks5://127.0.0.1:1080
`

### 3. 鎾ら攢浠ｇ悊

`powershell
.\git-proxy.ps1 -u
`

**鏁堟灉**:浠?~/.gitconfig 鍒犻櫎 http.proxy 鍜?https.proxy 涓ら」銆?
### 4. 鏌ョ湅褰撳墠浠ｇ悊鐘舵€?
`powershell
.\git-proxy.ps1 -c
`

**杈撳嚭绀轰緥**:
`
[INFO]  Current Git proxy configuration:
  http.proxy  = socks5://127.0.0.1:1080
  https.proxy = socks5://127.0.0.1:1080

[INFO]  Testing proxy connectivity...
[OK]    Proxy 127.0.0.1:1080 is reachable
`

浼氬仛涓€娆?TCP 杩為€氭€ф祴璇?2 绉掕秴鏃?,鍛婅瘔浣犱唬鐞嗙鍙ｆ槸鍚﹂€氥€?
---

## 鍥涖€佸弬鏁扮畝鍐?
| 瀹屾暣鍙傛暟 | 绠€鍐?| 璇存槑 |
|----------|------|------|
| -ProxyHost | -h | 浠ｇ悊 IP / 鍩熷悕 |
| -ProxyPort | -p | 浠ｇ悊绔彛 |
| -Set | -s | 搴旂敤璁剧疆 |
| -Unset | -u | 鎾ら攢浠ｇ悊 |
| -Check | -c | 鏌ョ湅鐘舵€?|
| -Help | 鈥?| 鏄剧ず甯姪 |

---

## 浜斻€佸父瑙佸満鏅?
### 鍦烘櫙 1:Clash / V2Ray 鏈湴浠ｇ悊

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 7890 -s   # Clash 榛樿 HTTP 绔彛 7890
.\git-proxy.ps1 -h 127.0.0.1 -p 10808 -s  # V2RayN 榛樿 SOCKS5 绔彛 10808
`

### 鍦烘櫙 2:SSH 璺虫澘鏈轰唬鐞?
`powershell
.\git-proxy.ps1 -h 10.0.0.20 -p 1080 -s
`

### 鍦烘櫙 3:涓存椂鎷変竴涓?repo,瀹屾垚鍚庢挙閿€

`powershell
.\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
git clone https://github.com/xxx/repo.git
.\git-proxy.ps1 -u
`

### 鍦烘櫙 4:鍦?Windows Terminal 涓粰甯哥敤浠ｇ悊鍋?alias

缂栬緫 $PROFILE:
`powershell
notepad C:\Users\Administrator\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
`

娣诲姞:
`powershell
function Set-GitProxy([string] = "127.0.0.1", [int] = 1080) {
    & "D:\Windows_Terminal\git-proxy.ps1" -h  -p  -s
}
function Unset-GitProxy { & "D:\Windows_Terminal\git-proxy.ps1" -u }
Set-Alias gpx Set-GitProxy
Set-Alias gpu Unset-GitProxy
`

涔嬪悗鍦ㄤ换浣曠洰褰?
`powershell
gpx 127.0.0.1 1080      # 璁剧疆
gpu                       # 鎾ら攢
`

---

## 鍏€佸簳灞傚懡浠?鏃犻渶鑴氭湰涔熻兘鐢?

`powershell
# 璁剧疆
git config --global http.proxy  socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 鎾ら攢
git config --global --unset http.proxy
git config --global --unset https.proxy

# 鏌ョ湅
git config --global --get http.proxy
git config --global --get https.proxy
`

---

## 涓冦€佽俯鍧戞彁绀?
| # | 闂 | 鍘熷洜 / 瑙ｅ喅 |
|---|------|------------|
| 1 | 鑴氭湰鎻愮ず銆屾棤娉曞姞杞?鍥犱负鍦ㄦ绯荤粺涓婄姝㈣繍琛岃剼鏈€?| PowerShell 榛樿 Restricted 绛栫暐,棣栨闇€鎵ц: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned |
| 2 | 浠ｇ悊璁句簡浣?git 杩樻槸鎱?| 妫€鏌ヤ唬鐞嗚蒋浠舵槸鍚﹀湪鐩戝惉绔彛;璇?git-proxy.ps1 -c 鐪嬭繛閫氭€?|
| 3 | 鍙褰撳墠椤圭洰鐢熸晥鑰岄潪鍏ㄥ眬 | 鑴氭湰鐢?--global,褰卞搷 ~/.gitconfig銆傛兂鍘绘帀灏辨敼 --global 涓?--local |
| 4 | ssh:// 鍗忚鐨?git 浠撳簱涓嶈蛋浠ｇ悊 | ssh 鍗忚闇€瑕侀厤 ~/.ssh/config 鐨?ProxyCommand,瑙佷笅鏂?|
| 5 | 鎾ら攢鍚庤繕鎻愮ず鏈変唬鐞?| 妫€鏌?~/.gitconfig 閲屾湁娌℃湁 http.* 鎴?url.* 鐨?[url] 閲嶅啓瑙勫垯 |

### SSH 鍗忚鐨勪唬鐞嗘柟妗?鑴氭湰涓嶆敮鎸?闇€鎵嬪姩)

缂栬緫 ~/.ssh/config:
`
Host github.com
    ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p
`

> 
c 鏄?netcat銆俉indows Git Bash 鑷甫;PowerShell 闇€鍙﹁銆?
---

## 鍏€佽剼鏈簮鐮?
瀹屾暣婧愮爜瑙?D:\Windows_Terminal\git-proxy.ps1,鏍稿績閫昏緫 12 琛?

`powershell
git config --global http.proxy  "socks5://:"
git config --global https.proxy "socks5://:"
`

`powershell
git config --global --unset http.proxy
git config --global --unset https.proxy
`

---

**鍏煎鎬?*:Windows Terminal 鉁?PowerShell 5.1+ 鉁?PowerShell 7 鉁?


---

# 鍏ㄥ眬璋冪敤閰嶇疆

> 璁?git-proxy 鍛戒护鍦ㄤ换浣曠洰褰曘€佷换浣曠粓绔兘鑳界洿鎺ヤ娇鐢?鏃犻渶 .\ 鍓嶇紑銆?
---

## 鏂瑰紡 1:鍔犲叆 PATH(鉁?宸查厤缃?鎺ㄨ崘)

鎶?D:\Windows_Terminal 鍔犲叆 **鐢ㄦ埛 PATH**,鏂板紑缁堢鍚庡嵆鍙叏灞€璋冪敤 git-proxy銆?
### 鎿嶄綔姝ラ(宸茶嚜鍔ㄥ畬鎴?

`powershell
 = [System.Environment]::GetEnvironmentVariable("Path", "User")
 = ";D:\Windows_Terminal"
[System.Environment]::SetEnvironmentVariable("Path", , "User")
`

**鎵嬪姩娣诲姞鏂规硶**:
1. Win + R 鈫?杈撳叆 sysdm.cpl 鈫?銆岄珮绾с€嶉€夐」鍗?2. 鐐瑰嚮銆岀幆澧冨彉閲忋€?3. 鍦ㄣ€岀敤鎴峰彉閲忋€嶆壘鍒?Path,鍙屽嚮缂栬緫
4. 鏂板缓涓€琛?濉叆 D:\Windows_Terminal
5. 纭畾 鈫?纭畾

> 娉ㄦ剰:淇敼 PATH 鍚?*蹇呴』鏂板紑涓€涓?Windows Terminal 绐楀彛**鎵嶇敓鏁堛€?
### 浣跨敤鏁堟灉

浠绘剰鐩綍銆佷换鎰忕粓绔?WT/CMD/PowerShell/VSCode 缁堢):

`cmd
git-proxy -Help
git-proxy -h 127.0.0.1 -p 1080 -s
git-proxy -u
git-proxy -c
`

鏃犻渶 cd 鍒拌剼鏈洰褰?鏃犻渶 .\ 鍓嶇紑銆?
---

## 鏂瑰紡 2:PowerShell 鍑芥暟 alias(浠?PowerShell)

缂栬緫 PowerShell profile,娣诲姞鍑芥暟:

`powershell
notepad C:\Users\Administrator\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
`

鍐欏叆:

`powershell
function git-proxy {
    & "D:\Windows_Terminal\git-proxy.ps1" @args
}
Set-Alias gpx git-proxy
`

淇濆瓨鍚?*鏂板紑 PowerShell 绐楀彛**,璋冪敤:
`powershell
git-proxy -h 127.0.0.1 -p 1080 -s
gpx -u                                  # 绠€鍐?`

> 浼樼偣:鍙敤 gpx 鐭悕;鍙嚜瀹氫箟鏇村琛屼负銆?> 缂虹偣:鍙湪 PowerShell 閲岃兘鐢?CMD 涓嶈銆?
---

## 鏂瑰紡 3:鏀捐繘宸叉湁 PATH 鐩綍(涓嶆帹鑽愭薄鏌撶郴缁熺洰褰?

`powershell
# 澶嶅埗鍒扮郴缁?PATH 鐩綍(闇€瑕佺鐞嗗憳)
copy D:\Windows_Terminal\git-proxy.cmd C:\Windows\System32\
`

涓嶆帹鑽?浼氭薄鏌撶郴缁熺洰褰曘€?
---

## 鎺ㄨ崘缁勫悎

**鏂瑰紡 1 + 鏂瑰紡 2 鍚屾椂閰嶇疆**:

- CMD / Git Bash / 鏃х粓绔?鐢?git-proxy 鍛戒护
- PowerShell:鐢?git-proxy 鎴栧埆鍚?gpx

涓よ€呬簰涓嶅啿绐?鍔熻兘瀹屽叏涓€鑷淬€?
---

## 楠岃瘉鏂规硶

鏂板紑涓€涓?Windows Terminal 绐楀彛,鎵ц:

`powershell
where.exe git-proxy     # CMD 楠岃瘉
Get-Command git-proxy    # PowerShell 楠岃瘉
`

搴旇繑鍥?
`
D:\Windows_Terminal\git-proxy.cmd
`

涔嬪悗浠讳綍鐩綍閮藉彲:
`powershell
git-proxy -h 10.0.0.20 -p 1080 -s    # 璁剧疆
git-proxy -c                              # 鏌ョ湅
git-proxy -u                              # 鎾ら攢
`

---

## 鏁呴殰鎺掓煡

| 闂 | 瑙ｅ喅 |
|------|------|
| git-proxy 涓嶆槸鍐呴儴鎴栧閮ㄥ懡浠?| PATH 娌＄敓鏁?**閲嶆柊鎵撳紑缁堢** |
| 鏀?PATH 鍚庝粛鎵句笉鍒?| 妫€鏌ユ嫾鍐?蹇呴』鏄?D:\Windows_Terminal,甯﹀垎鍙峰垎闅?|
| 鑴氭湰鑳借窇浣嗗弬鏁颁笉鐢熸晥 | CMD 涓嬪弬鏁拌鐢?-h IP -p 绔彛 -s 涓夋鍐?涓嶈兘鍚堝苟 |
| 鎻愮ず鎵ц绛栫暐閿欒 | 绗竴娆¤繍琛?Set-ExecutionPolicy -Scope CurrentUser RemoteSigned |

---

**褰撳墠鐘舵€?*:鉁?宸查厤缃柟寮?1 + 宸插垱寤?D:\Windows_Terminal\git-proxy.cmd 鍖呰鍣?


---

# SSH 瀵嗛挜鐧诲綍瀹屾暣鎸囧崡

> Windows Terminal 涓厤缃?SSH 鍏閽ョ櫥褰?鍏嶅瘑鐮佽繛鏈嶅姟鍣?椤轰究璁茶鎺掓煡"鏄庢槑浼犱簡鍏挜杩樻槸瑕佸瘑鐮?鐨勫父瑙佸潙銆?
---

## 涓€銆佷负浠€涔堢敤瀵嗛挜鐧诲綍

- 姣斿瘑鐮佸畨鍏?瀵嗙爜鍙兘琚垎鐮?瀵嗛挜鍑犱箮涓嶅彲鑳?
- 涓嶇敤姣忔鏁插瘑鐮?- 鍙互閰嶅涓湇鍔″櫒鍏辩敤涓€鎶婂瘑閽?- 閰嶅悎 ssh-agent 杩?GitHub / GitLab 閮藉厤瀵?
---

## 浜屻€佺敓鎴愬瘑閽ュ

### 鐜颁唬鎺ㄨ崘:ED25519

`powershell
ssh-keygen -t ed25519 -f "C:\Users\Administrator\.ssh\id_ed25519" -C "your_email@example.com"
`

- 绠楁硶鏂般€佸瘑閽ョ煭(~68 瀛楄妭)銆侀€熷害蹇€佸畨鍏ㄦ€ч珮
- OpenSSH 6.5+ 閮芥敮鎸?2014 骞磋捣,鎵€鏈夌幇浠ｆ湇鍔″櫒閮借)

### 鍏煎鑰佹湇鍔″櫒:RSA 4096

`powershell
ssh-keygen -t rsa -b 4096 -f "C:\Users\Administrator\.ssh\id_rsa" -C "your_email@example.com"
`

### 浜や簰杩囩▼

`
Enter passphrase (empty for no passphrase):  # 寮虹儓寤鸿璁惧瘑鐮?闃茬閽ユ硠闇?Enter same passphrase again:
Your identification has been saved in C:\Users\xxx\.ssh\id_ed25519
Your public key has been saved in C:\Users\xxx\.ssh\id_ed25519.pub
`

### 绉侀挜瀹夊叏寤鸿

`powershell
# Windows 涓?绉侀挜鏉冮檺榛樿灏卞彧鏈夊綋鍓嶇敤鎴疯兘璇?闂涓嶅ぇ
# 浣嗗鏋滅敤杩?Git Bash,鍙兘鏉冮檺琚敼鍧?闇€瑕佷慨澶?icacls "C:\Users\Administrator\.ssh\id_ed25519" /inheritance:r /grant:r ""
`

---

## 涓夈€佹妸鍏挜浼犲埌鏈嶅姟鍣?
### 鏂规硶 1:鎵嬪姩澶嶅埗(鏈€绋?

`powershell
# 1. 澶嶅埗鍏挜鍐呭
Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"
# 杈撳嚭:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your_email@example.com
`

鐒跺悗鍦ㄦ湇鍔″櫒涓?

`ash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA..." >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
`

### 鏂规硶 2:鐢?ssh-copy-id(Linux/Mac 鎵嶆湁)

`ash
ssh-copy-id -i ~/.ssh/id_ed25519.pub yao@10.0.0.10
`

> Windows 娌℃湁 ssh-copy-id銆傚彲浠ヤ粠 Git Bash 璋冪敤,鎴栫敤鏂规硶 1銆?
### 鏂规硶 3:鐢?PowerShell 鑷姩浼?闇€鍏堣兘瀵嗙爜鐧诲綍涓€娆?

`powershell
# 鎶婂叕閽ュ唴瀹逛綔涓哄瘑鐮佷紶鍏?涓嶅畨鍏ㄤ絾鏂逛究)
 = Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"
ssh yao@10.0.0.10 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
`

---

## 鍥涖€侀厤缃?~/.ssh/config(寮虹儓鎺ㄨ崘)

鎶婂父鐢ㄦ湇鍔″櫒鍐欒繘閰嶇疆,浠ュ悗涓€琛屽懡浠よ繛:

`powershell
notepad C:\Users\Administrator\.ssh\config
`

绀轰緥鍐呭:

`
# GitHub
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# 宸ヤ綔鏈嶅姟鍣?Host work
    HostName 10.0.0.10
    User yao
    Port 22
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3

# 璺虫澘鏈?Host jump
    HostName jump.example.com
    User myuser
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    ProxyCommand none

# 鍏ㄥ眬閰嶇疆(鎵€鏈夎繛鎺ョ敓鏁?
Host *
    AddKeysToAgent yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
`

涔嬪悗:

`powershell
ssh work                   # 鐩存帴杩?涓嶇敤杈?yao@10.0.0.10
ssh work "ls -la"          # 鐩存帴璺戝懡浠?scp file.txt work:~/       # 鐩存帴 scp
`

Windows 涓婅寰楃粰 config 鏂囦欢璁炬潈闄?閬垮厤 ssh 璀﹀憡:

`powershell
icacls "C:\Users\Administrator\.ssh\config" /inheritance:r /grant:r ""
`

---

## 浜斻€佹祴璇曞瘑閽ョ櫥褰?
`powershell
# 璇︾粏鏃ュ織妯″紡(绗竴娆¤皟璇曠敤)
ssh -v work

# 鍏抽敭鐪嬭繖涓よ:
# debug1: Offering public key: ED25519 SHA256:xxxxx
# debug1: Authentication succeeded (publickey).   鈫?鎴愬姛
# debug1: Permission denied (publickey,password). 鈫?澶辫触,瑙佷笅鏂囨帓鏌?`

纭鎴愬姛:

`powershell
ssh work "echo 'OK, key login works without password'"
`

---

## 鍏€佸瘑閽ョ櫥褰曞け璐ョ殑鎺掓煡娓呭崟

### 鐥囩姸:Permission denied (publickey,password) 鎴栫户缁姹傚瘑鐮?
鎸夎繖涓『搴忔帓鏌?

#### 1. 鏈嶅姟鍣ㄧ authorized_keys 鍐呭鏄惁姝ｇ‘

`ash
# 鍦ㄦ湇鍔″櫒涓?cat ~/.ssh/authorized_keys
`

蹇呴』鏄?*涓€鏁磋**,鍐呭璺?id_ed25519.pub 瀹屽叏涓€鑷?

`
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxSE/jWjOFjtePtlne17BTbNPJ0wYCIAfSxy7G/bBJs Administrator@DESKTOP-SPOC18S
`

甯歌閿欒:
- 澶嶅埗鏃跺/灏戜簡绌烘牸
- Windows 鎹㈣绗?\r\n 琚鍒惰繘鍘讳簡(鍦?Linux 涓?\r 涔熶細琚鎴愬叕閽ヤ竴閮ㄥ垎)
- 鍏挜鏈熬鐨勬敞閲婇偖绠辫鎴柇
- **绮樿创鏃跺浜嗕竴琛?*(姣忚涓€涓叕閽?椤哄簭鏃犳墍璋?

**閲嶆柊鐢熸垚鐨勫懡浠?鍦ㄦ湇鍔″櫒涓?**:

`ash
yao@server:~$ nano ~/.ssh/authorized_keys
# 娓呯┖,绮樿创瀹屾暣涓€琛?Ctrl+O 淇濆瓨,Ctrl+X 閫€鍑?`

> 鐜板湪浣犺浜?nano,鍙互鐢ㄤ簡銆?
#### 3. 鏉冮檺闂(90% 鐨勫潙鍦ㄨ繖閲?

鏈嶅姟绔?SSH daemon **鏋佸叾鎸戝墧**鏂囦欢鏉冮檺:

`ash
yao@server:~$ ls -la ~/.ssh/
# 蹇呴』涓ユ牸:
# drwx------ (700)  .ssh
# -rw------- (600)  authorized_keys
# -rw------- (600)  id_ed25519  (濡傛灉鏄閽ュ湪鏈嶅姟鍣?

yao@server:~$ chmod 700 ~/.ssh
yao@server:~$ chmod 600 ~/.ssh/authorized_keys
yao@server:~$ chown yao:yao ~/.ssh -R
`

#### 4. sshd_config 鏄惁鍏佽鍏挜璁よ瘉

`ash
yao@server:~$ sudo grep -E "^(PubkeyAuthentication|PermitRootLogin|AuthorizedKeysFile)" /etc/ssh/sshd_config
`

杈撳嚭搴旇鏄?

`
PubkeyAuthentication yes
PermitRootLogin prohibit-password  # 鎴?yes
AuthorizedKeysFile .ssh/authorized_keys
`

濡傛灉 PubkeyAuthentication 鏄?
o,鏀瑰洖鏉?

`ash
yao@server:~$ sudo sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
yao@server:~$ sudo systemctl restart sshd
`

#### 5. 瀹㈡埛绔敤鐨勬槸鍝釜瀵嗛挜

`powershell
# 鐪?SSH 瀹為檯灏濊瘯鐨勫瘑閽?ssh -v work 2>&1 | Select-String "Offering public key"
`

濡傛灉娌＄湅鍒?鍙兘鏄?config 鏂囦欢 IdentityFile 鍐欓敊浜嗚矾寰勩€?
#### 6. 鏈嶅姟鍣ㄦ棩蹇?缁堟瀬鎺掓煡)

`ash
# 鏈嶅姟鍣ㄤ笂
yao@server:~$ sudo tail -f /var/log/auth.log    # Debian/Ubuntu
yao@server:~$ sudo tail -f /var/log/secure      # CentOS/RHEL
`

鐒跺悗鍦ㄥ鎴风灏濊瘯杩炴帴,鏃ュ織浼氭樉绀哄叿浣撴嫆缁濆師鍥?姣斿:

`
Authentication refused: bad ownership or modes for file /home/yao/.ssh/authorized_keys
`

---

## 涓冦€乻sh-agent:鍏嶈緭瀵嗛挜瀵嗙爜

濡傛灉绉侀挜璁句簡 passphrase(寮烘帹),鍙互閰嶇疆 ssh-agent 缂撳瓨,鍏嶆瘡娆¤緭鍏?

`powershell
# 鍚姩 ssh-agent 鏈嶅姟(Windows 鑷甫)
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

# 娣诲姞绉侀挜(鍙渶鍋氫竴娆?浼氶棶涓€娆?passphrase)
ssh-add C:\Users\Administrator\.ssh\id_ed25519

# 涔嬪悗 ssh work 閮戒笉鐢ㄨ緭瀵嗙爜浜?`

---

## 鍏€佹枃浠朵紶杈撻厤鍚堝瘑閽?
涔嬪墠瑁呯殑 scp / sftp 浼氳嚜鍔ㄧ敤 ~/.ssh/config 閲岀殑瀵嗛挜,鐩存帴鍏嶅瘑:

`powershell
# 涓婁紶鏂囦欢
scp test.txt work:~/test.txt

# 涓嬭浇
scp work:~/data.csv .

# 鏁翠釜鐩綍
scp -r myproject/ work:~/myproject/

# 浜や簰寮?SFTP
sftp work
`

---

## 涔濄€佸鏈嶅姟鍣ㄧ鐞嗗疄璺?
### 涓€鎶婂瘑閽ヨ蛋澶╀笅

`
~/.ssh/
鈹溾攢鈹€ id_ed25519           # 绉侀挜
鈹溾攢鈹€ id_ed25519.pub       # 鍏挜,鏀惧埌鎵€鏈夋湇鍔″櫒
鈹溾攢鈹€ config               # 鏈嶅姟鍣ㄦ竻鍗?鈹斺攢鈹€ known_hosts          # 宸蹭俊浠绘湇鍔″櫒鎸囩汗
`

鎶婂叕閽ュ姞鍒版墍鏈夋湇鍔″櫒:

`ash
# 鍚屼竴鍏挜,鎺ㄥ埌澶氫釜鏈嶅姟鍣?for host in server1 server2 server3; do
    ssh-copy-id -i ~/.ssh/id_ed25519.pub yao@System.Management.Automation.Internal.Host.InternalHost
done
`

### 涓嶅悓鏈嶅姟鍣ㄧ敤涓嶅悓瀵嗛挜(鏇村畨鍏?

`
~/.ssh/
鈹溾攢鈹€ id_ed25519_work
鈹溾攢鈹€ id_ed25519_personal
鈹溾攢鈹€ id_ed25519_github
`

config 鏂囦欢鍒嗗埆鎸囧畾:

`
Host github.com
    IdentityFile ~/.ssh/id_ed25519_github

Host work
    IdentityFile ~/.ssh/id_ed25519_work
`

---

## 鍗併€侀€熸煡琛?
`powershell
# 鐢熸垚瀵嗛挜
ssh-keygen -t ed25519 -f "C:\Users\Administrator\.ssh\id_ed25519" -C "澶囨敞"

# 鏄剧ず鍏挜
Get-Content "C:\Users\Administrator\.ssh\id_ed25519.pub"

# 娣诲姞鍒?ssh-agent(鍏嶈緭 passphrase)
ssh-add C:\Users\Administrator\.ssh\id_ed25519

# 娴嬭瘯杩炴帴
ssh -v work

# 浼犳枃浠?scp file.txt work:~/
sftp work

# 缂栬緫 config
code "C:\Users\Administrator\.ssh\config"
`

---

## 鍗佷竴銆佸父瑙侀敊璇€熸煡

| 閿欒 | 鍘熷洜 | 瑙ｅ喅 |
|------|------|------|
| Permission denied (publickey) | 鍏挜璁よ瘉澶辫触 | 妫€鏌?uthorized_keys 鍐呭銆佹潈闄?|
| 鎻愮ず Bad owner or permissions on ~/.ssh/config | Windows 涓婃潈闄愯繃瀹?| icacls config /inheritance:r /grant:r "" |
| Too many authentication failures | 閰嶇疆浜嗗涓?IdentityFile | 鍦?config 鐢?-o IdentitiesOnly=yes |
| sign_and_send_pubkey: signing failed | ssh-agent 娌″惎鎴栨病鍔犵閽?| ssh-add 涓€涓?|
| Host key verification failed | 鏈嶅姟鍣ㄩ噸瑁呰繃/瀵嗛挜鍙樹簡 | ssh-keygen -R work 鍒犳棫鎸囩汗鍐嶈繛 |
| Connection timed out | 闃茬伀澧?缃戠粶闂 | Test-NetConnection work -Port 22 |
| 澶嶅埗鍏挜鏃跺浜嗕竴琛?瀵艰嚧绗簩琛屽唴瀹硅褰撴垚瀵嗙爜 | 澶嶅埗绮樿创闂 | 鐢?nano 缂栬緫纭鍙湁涓€琛?|

---

**閫傜敤**:OpenSSH 7.7+ (Windows 10 1809 鑷甫)


---

# Debian / Linux 鐗?git-proxy 閮ㄧ讲瀹炴垬

> 鍦ㄨ繙绔?Debian 13 鏈嶅姟鍣?10.0.0.10,鐢ㄦ埛 yao)涓婇儴缃?git-proxy bash 鐗堢殑瀹屾暣杩囩▼ + 涓€涓殣钄藉潙銆?
---

## 涓€銆佷笌 Windows 鐗堢殑鍖哄埆

| 椤圭洰 | Windows 鐗?| Debian 鐗?|
|------|------------|-----------|
| 鑴氭湰璇█ | PowerShell | Bash |
| 鏂囦欢 | git-proxy.ps1 | git-proxy-debian.sh |
| 瀹夎浣嶇疆 | PATH 浠绘剰鐩綍 | /home/<user>/bin/ (鐢ㄦ埛绾? 鎴?/usr/local/bin/ (闇€瑕?sudo) |
| 璋冪敤鏂瑰紡 | git-proxy | git-proxy (瑕?~/bin 鍦?PATH) |
| Git 璺緞 | 鑷姩 (PowerShell 鐭ラ亾) | **闇€瑕佹樉寮忓鐞?*(瑙佷笅鏂囪俯鍧? |

---

## 浜屻€侀儴缃叉楠?
### 1. 涓婁紶鑴氭湰鍒版湇鍔″櫒

`powershell
# Windows 绔墽琛?scp D:\Windows_Terminal\git-proxy-debian.sh yao@10.0.0.10:/tmp/git-proxy.sh
`

### 2. 瀹夎鍒扮敤鎴风洰褰?鏃犻渶 sudo)

`ash
# 鏈嶅姟鍣ㄧ
mkdir -p ~/bin
mv /tmp/git-proxy.sh ~/bin/git-proxy
chmod +x ~/bin/git-proxy
`

### 3. 閰嶇疆 PATH

SSH non-interactive shell 榛樿**涓?*璇诲彇 ~/.bashrc,鎵€浠ユ渶濂藉悓鏃舵敼涓や釜鏂囦欢:

`ash
# 浜や簰寮?shell 鐢?(SSH 鐧诲綍鍚?
echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.bashrc

# 闈炰氦浜掑紡 shell 鐢?(SSH 鐩存帴鎵ц鍛戒护)
echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.profile
`

### 4. 娴嬭瘯

`ash
# 鐧诲綍鍚?git-proxy --help

# SSH 涓€琛屾墽琛?ssh yao@10.0.0.10 "git-proxy --help | head -3"
`

---

## 涓夈€侀殣钄借俯鍧?Git not found 閿欒

### 鐜拌薄

`ash
yao@debian:~$ git-proxy -t
[ERROR] Git not found. Please install: sudo apt install git
`

浣嗗叾瀹?git 鏄庢槑瑁呭湪 /usr/bin/git:

`ash
yao@debian:~$ git --version
git version 2.47.3
`

### 鏍瑰洜鍒嗘瀽

**SSH non-interactive shell 鐨?PATH 涓嶅寘鍚?/usr/bin**!

鎺掓煡杩囩▼:

`ash
# 1. SSH 鐩存帴鎵ц鍛戒护(闈炰氦浜?shell)
yao@debian:~$ ssh yao@10.0.0.10 "echo \"
/usr/local/bin:/usr/bin   # 杩欑湅璧锋潵鏄?OK 鐨?
# 2. 浣嗙敤 sudo 鏃?浼氶噸缃?PATH)
yao@debian:~$ ssh yao@10.0.0.10 "sudo env"
# secure_path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# (榛樿 PATH 鍙嶈€屾槸瀹屾暣鐨?

# 3. 鐪熸璇″紓鐨勬儏鍐?鏌愪簺瀹瑰櫒/minimal Debian 瀹夎
# 鐢ㄦ埛瀹剁洰褰曚笅 .bashrc / .profile 娌¤璇诲彇
# 鎴栬€?PATH 琚?systemd / PAM 閲嶇疆鎴愮┖ / 鏈€灏忓€?`

### 淇鏂规(宸插悎鍏?git-proxy-debian.sh)

鑴氭湰鍐呴儴鍋氫簡涓変欢浜?涓嶅啀渚濊禆澶栭儴 PATH:

`ash
# 1. 寮哄埗 export 鏍囧噯 PATH
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\"

# 2. 鎸夊父瑙佽矾寰勭‖缂栫爜鏌ユ壘 git
GIT_CMD=""
for p in /usr/bin/git /usr/local/bin/git /bin/git; do
    if [[ -x "\" ]]; then
        GIT_CMD="\"
        break
    fi
done

# 3. 鏈€鍚庡洖閫€鍒?command -v
if [[ -z "\" ]]; then
    GIT_CMD=\
fi

# 4. 鎵€鏈?git 璋冪敤閮芥敼鎴?\
\ config --global http.proxy "..."
`

### 楠岃瘉鑴氭湰鑷粰鑷冻

`ash
# 妯℃嫙鏈€灏?PATH 鐜
yao@debian:~$ env -i HOME=/home/yao PATH=/tmp /home/yao/bin/git-proxy --help
Git Proxy Manager (HTTP / HTTPS / SOCKS5) - Debian/Linux
...
# 浠嶇劧姝ｅ父宸ヤ綔!璇存槑鑴氭湰涓嶄緷璧栧閮?PATH
`

---

## 鍥涖€佸畬鏁寸殑 Debian 瀹夎鑴氭湰(鍙洿鎺ュ鍒?

`ash
#!/bin/bash
# install-git-proxy.sh - 涓€閿畨瑁呰剼鏈?set -e

echo "=== 1. 鍑嗗鐩綍 ==="
mkdir -p ~/bin

echo "=== 2. 澶嶅埗鑴氭湰(鍋囪浣犲凡 scp 鍒?/tmp) ==="
if [[ -f /tmp/git-proxy-debian.sh ]]; then
    mv /tmp/git-proxy-debian.sh ~/bin/git-proxy
elif [[ -f ~/git-proxy-debian.sh ]]; then
    cp ~/git-proxy-debian.sh ~/bin/git-proxy
else
    echo "璇峰厛涓婁紶 git-proxy-debian.sh 鍒?/tmp/ 鎴?~/" >&2
    exit 1
fi

echo "=== 3. 璁剧疆鏉冮檺 ==="
chmod +x ~/bin/git-proxy

echo "=== 4. 閰嶇疆 PATH ==="
grep -q 'HOME/bin' ~/.bashrc 2>/dev/null || echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.bashrc
grep -q 'HOME/bin' ~/.profile 2>/dev/null || echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.profile

echo "=== 5. 娴嬭瘯 ==="
~/bin/git-proxy --help | head -3

echo ""
echo "=== 瀹夎瀹屾垚 ==="
echo "鐜板湪鍙互鐢? git-proxy -h <IP> -p <PORT> -s"
`

---

## 浜斻€丏ebug 閫熸煡

`ash
# 1. PATH 鍒板簳鏈変粈涔?echo \

# 2. git 鍦ㄥ摢
ls -la /usr/bin/git /usr/local/bin/git /bin/git 2>&1

# 3. git-proxy 瑙ｆ瀽鍚庣殑 GIT_CMD 鏄暐
bash -x ~/bin/git-proxy --help 2>&1 | grep -E "GIT_CMD=|command -v"

# 4. 寮哄埗鐢ㄧ粷瀵硅矾寰勮窇
/usr/bin/git --version

# 5. 涓存椂寮哄埗璁剧疆 PATH 娴嬭瘯
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin git-proxy -t
`

---

## 鍏€佹暀璁?
| # | 鏁欒 |
|---|------|
| 1 | **姘歌繙涓嶈鍋囪 PATH 鍖呭惈 /usr/bin**鈥斺€斿挨鍏跺湪鑴氭湰涓皟鐢ㄥ叾浠栧懡浠ゆ椂 |
| 2 | SSH non-interactive shell 鐨?PATH 鍙兘**瀹屽叏涓嶈鍙?* .bashrc/.profile |
| 3 | sudo 浼?*閲嶇疆 PATH** 鍒?secure_path,杩欐槸鍙︿竴灞傚鏉傛€?|
| 4 | 璺ㄥ钩鍙拌剼鏈鎸夊父瑙佷綅缃?*纭紪鐮佹煡鎵?*鍏抽敭鍛戒护,鎴栨樉寮?export PATH |
| 5 | 鐢?ash -x 璋冭瘯鑴氭湰鍙互鐪嬫竻妤氭瘡涓€姝ュ疄闄呮墽琛屼簡浠€涔?|

---

**閫傜敤**:Debian 11+ / Ubuntu 20.04+ / 鍏朵粬浣跨敤 systemd 鐨勭幇浠?Linux 鍙戣鐗?


---

# PowerShell SSH 杞箟瀵艰嚧 .bashrc 琚啓鍧忕殑鍧?
> 瀹炰綋 terminal 閲?git-proxy 鎶?鎵句笉鍒板懡浠?鐨勭湡姝ｅ師鍥犮€?
---

## 涓€銆佺棁鐘?
瀹炰綋鐧诲綍 SSH 鍚?

`ash
yao@debian:~$ git-proxy -t
bash: git-proxy -t : 鎵句笉鍒拌繖涓懡浠?`

鏄庢槑鑴氭湰鍦?~/bin/git-proxy,鑰屼笖 ~/bin/git-proxy --help 鐩存帴璋冪敤鑳界敤銆?
---

## 浜屻€佹牴鏈師鍥?
涔嬪墠鐢?PowerShell 閫氳繃 SSH 杩滅▼鍐欏叆 PATH 閰嶇疆鏃?**瀛楃涓茶浆涔夊嚭閿?*:

`powershell
# 鏈剰鏄啓鍏?export PATH=\C:\Users\Administrator/bin:\

# PowerShell 杞箟鍚庡彉鎴?export PATH=\C:\Users\Administrator/bin:\

# 钀藉埌 Linux .bashrc 閲屽氨鍙樻垚浜?Windows 璺緞!
`

鏈€缁?.bashrc 閲岃鍐欏叆浜?*涓よ**鍨冨溇:

`
export PATH=\C:\Users\Administrator/bin:\
export PATH=\C:\Users\Administrator/bin:\
`

杩欎袱琛?PATH 鍦?Linux 涓?*瀹屽叏鏃犳晥**(Windows 璺緞),鑰屼笖鍥犱负 \ 琚悶鎺?杩樻妸鍚庨潰鐪熸鐨?PATH 缁欐埅鏂簡銆?
---

## 涓夈€佹帓鏌ヨ繃绋?
### 1. 鐪?PATH 閲屾湁浠€涔?
`ash
yao@debian:~$ echo \
# 濂囨€殑杈撳嚭閲岃兘鐪嬪埌 C:\Users\Administrator/bin 瀛楁牱
`

### 2. 鐪?.bashrc 鏈熬

`ash
yao@debian:~$ tail -10 ~/.bashrc

# 鎵惧埌浜?
export PATH=\C:\Users\Administrator/bin:\
export PATH=\C:\Users\Administrator/bin:\
`

---

## 鍥涖€佷慨澶?
`ash
# 1. 澶囦唤(闃叉墜鎶?
cp ~/.bashrc ~/.bashrc.bak
cp ~/.profile ~/.profile.bak

# 2. 鍒犻櫎鍖呭惈 Administrator 鐨勮
grep -v 'Administrator' ~/.bashrc > /tmp/bashrc.new
mv /tmp/bashrc.new ~/.bashrc

# 3. 鐢?**鍙屽紩鍙?* 鍐欏叆姝ｇ‘ PATH(鍗曞紩鍙蜂細璁?\C:\Users\Administrator 瀛楅潰鍖?
echo 'export PATH="C:\Users\Administrator/bin:"' >> ~/.bashrc
echo 'export PATH="C:\Users\Administrator/bin:"' >> ~/.profile

# 4. 楠岃瘉
tail -5 ~/.bashrc
# 搴旇鐪嬪埌:
# export PATH="C:\Users\Administrator/bin:"

# 5. 绔嬪嵆鐢熸晥(鏃犻渶閲嶆柊鐧诲綍)
source ~/.bashrc

# 6. 娴嬭瘯
git-proxy -t
`

鎴栬€呯敤涓€閿慨澶嶈剼鏈?宸蹭笂浼?ix-bashrc.sh):

`ash
scp fix-bashrc.sh yao@server:/tmp/
ssh yao@server "bash /tmp/fix-bashrc.sh"
`

---

## 浜斻€佹暀璁?瀵硅嚜鍔ㄥ寲杩愮淮寰堥噸瑕?

| # | 鏁欒 |
|---|------|
| 1 | **PowerShell 鈫?SSH 鈫?bash** 杩欐潯閾捐矾涓婄殑瀛楃涓茶浆涔?*鏋佸叾瀹规槗鍑洪敊** |
| 2 | \C:\Users\Administrator 鍦?PowerShell 閲屼細琚浆涔?鍦?bash 閲屽鏋滅敤鍗曞紩鍙峰張涓嶄細灞曞紑,**姘歌繙鏄潙** |
| 3 | 鍐欏叆 .bashrc 杩欑鍏抽敭閰嶇疆鏂囦欢,**涓€瀹氳鍏堝浠?* |
| 4 | 杩滅▼淇敼鍚?*绔嬪嵆楠岃瘉**(鐢?	ail -5 鐪嬪疄闄呭唴瀹?,鍒瓑鐢ㄦ埛鎶?鍛戒护鎵句笉鍒?鎵嶅彂鐜?|
| 5 | 鐢?*鏂囦欢涓婁紶**鑰屼笉鏄?echo ... >> 杩滅▼鎷兼帴瀛楃涓?閬垮厤鎵€鏈夎浆涔夐棶棰?|

### 姝ｇ‘鐨勮繙绋嬪啓鍏ュЭ鍔?
`powershell
# 鉂?閿欒:浼氳杞箟鎼炲潖
ssh user@server "echo 'export PATH=\C:\Users\Administrator/bin:\' >> ~/.bashrc"

# 鉁?姝ｇ‘:涓婁紶鑴氭湰鏂囦欢,鍦ㄦ湇鍔″櫒涓婃墽琛?scp fix-script.sh user@server:/tmp/
ssh user@server "bash /tmp/fix-script.sh"

# 鉁?鎴栬€?鐢?here-string 鍦?PowerShell 閲屾瀯閫?SSH 浼?stdin
 = @'
export PATH="C:\Users\Administrator/bin:"
'@
 | ssh user@server "cat >> ~/.bashrc"
`

### 鏇村畨鍏ㄧ殑鍋氭硶:鍦ㄨ剼鏈《閮ㄦ鏌?PATH

濡傛灉 git-proxy 鑴氭湰鑷繁鑳戒繚璇?PATH,灏变笉闇€瑕佷緷璧?.bashrc:

`ash
# git-proxy-debian.sh 澶撮儴宸茬粡鍋氫簡:
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\"

# 鎵€浠ュ嵆浣?.bashrc 鍐欏潖浜?git-proxy 涔熻兘鐢?浣嗗墠鎻愭槸 ~/bin/git-proxy 瀛樺湪)
`

---

**鐩稿叧鏂囦欢**: ix-bashrc.sh(涓€閿慨澶嶅伐鍏?

**鎺ㄩ€佸埌 GitHub**: https://github.com/yao1987825/windows-terminal/blob/main/INSTALL.md


---

# wget / curl 鍦?Windows Terminal 鐨勬纭敤娉?
> `wget` 鍜?`curl` 鍦?PowerShell 閲岃鍔寔浜?鈥?鍒啀鐢ㄩ敊鏂瑰紡涓嬭浇鏂囦欢浜嗐€?
---

## 涓€銆侀棶棰樼幇璞?
```powershell
PS C:\Users\Administrator> wget --help
# 鎶ラ敊: 涓嶈兘璇嗗埆 --help
# 鎴栬€呮樉绀?Invoke-WebRequest 鐨勫府鍔?
PS C:\Users\Administrator> wget "https://example.com/file.zip" -O "file.zip"
# 鎶ラ敊: A parameter cannot be found that accepts argument '-O'
```

### 鍘熷洜

Windows PowerShell 鎶?`wget` 鍜?`curl` 閮?*鍒悕鎸囧悜** `Invoke-WebRequest`:

```powershell
PS> Get-Command wget
CommandType  Name    Definition
-----------  ----    ----------
Alias        wget    -> Invoke-WebRequest

PS> Get-Command curl
CommandType  Name    Definition
-----------  ----    ----------
Alias        curl    -> Invoke-WebRequest
```

`Invoke-WebRequest` 鏄?PowerShell 鐨勪笅杞藉懡浠?璇硶璺?GNU wget/curl **瀹屽叏涓嶅悓**銆?
---

## 浜屻€佷笁绉嶈В鍐虫柟妗?
### 鏂规 1: 鐢ㄧ湡瀹炵▼搴忓悕(鏈€绠€鍗?

GNU wget 鍜?curl.exe 閮芥槸鐙珛 exe,Windows Terminal 閮借兘鐢ㄣ€?
```powershell
# 鐪熷疄 wget (宸查€氳繃 Chocolatey 瀹夎)
wget.exe "URL" -O "save_path"

# 鐪熷疄 curl (Windows 10 1803+ 鑷甫)
curl.exe -L -o "save_path" "URL"
```

**鍏抽敭**:**蹇呴』鍔?`.exe` 鍚庣紑**,鍚﹀垯浼氳 PowerShell 鍒悕鎷︽埅銆?
#### 楠岃瘉鐪熷疄绋嬪簭浣嶇疆

```powershell
where.exe wget
# C:\ProgramData\chocolatey\bin\wget.exe

where.exe curl
# C:\Windows\system32\curl.exe
```

---

### 鏂规 2: 姘镐箙绉婚櫎 PowerShell 鍒悕(鎺ㄨ崘)

鍔犲埌 PowerShell profile (`$PROFILE`):

```powershell
notepad $PROFILE
```

娣诲姞:

```powershell
# 璁?wget/curl 榛樿灏辨槸鐪熷疄鍛戒护
Remove-Item Alias:wget -Force -ErrorAction SilentlyContinue
Remove-Item Alias:curl -Force -ErrorAction SilentlyContinue
```

鏂板紑缁堢鍚?鐩存帴 `wget URL -O file` 灏辫兘鐢ㄣ€?
---

### 鏂规 3: 鐢?PowerShell 鍘熺敓鍛戒护

濡傛灉涓嶄笅杞藉閮ㄥ伐鍏?鐩存帴鐢?`Invoke-WebRequest`:

```powershell
# 涓嬭浇鍒版枃浠?Invoke-WebRequest -Uri "https://example.com/file.zip" -OutFile "file.zip"

# 绠€鍐?aliased to iwr)
iwr "URL" -OutFile "file.zip"

# 鏄剧ず杩涘害
Invoke-WebRequest -Uri "URL" -OutFile "file.zip" -Verbose

# POST 璇锋眰
Invoke-RestMethod -Uri "https://api.example.com" -Method Post `
    -Body '{"key":"value"}' `
    -ContentType "application/json"
```

---

## 涓夈€佸疄鎴樺懡浠ゅぇ鍏?
### 1. 涓嬭浇鍗曟枃浠?
```powershell
# wget 椋庢牸
wget.exe -c "https://example.com/large-file.zip" -O "D:\Downloads\file.zip"

# curl 椋庢牸
curl.exe -L -o "D:\Downloads\file.zip" "https://example.com/large-file.zip"
```

鍙傛暟:
| 宸ュ叿 | 鍙傛暟 | 浣滅敤 |
|------|------|------|
| wget | `-c` | 鏂偣缁紶 |
| wget | `-tries=N` | 閲嶈瘯 N 娆?|
| wget | `-timeout=S` | 瓒呮椂绉掓暟 |
| curl | `-L` | 璺熼殢閲嶅畾鍚?|
| curl | `-C -` | 鏂偣缁紶 |
| curl | `--retry N` | 閲嶈瘯 |

### 2. 閫氳繃 GitHub 浠ｇ悊涓嬭浇 Release 鏂囦欢

```powershell
# URL 妯℃澘
# https://gh-proxy.org/https://github.com/USER/REPO/releases/download/TAG/FILE
# 鎴?https://v4.gh-proxy.org/...

# 涓嬭浇 N1 OpenWrt 鍥轰欢 (279 MB)
wget.exe -c --tries=10 --timeout=60 `
    "https://v4.gh-proxy.org/https://github.com/yao1987825/Cloud-N1-OpenWrt/releases/download/20260918/openwrt_s905d_n1_R26.03.25_k6.12.65-flippy-94+.img.gz" `
    -O "D:\Downloads\openwrt_n1.img.gz"
```

**URL 蹇呴』鐢ㄥ紩鍙峰寘**!鏂囦欢鍚嶉噷鏈?`+`銆乣.` 绛夊瓧绗?PowerShell 涓嶅姞寮曞彿浼氳В鏋愰敊銆?
### 3. 涓嬭浇澶氫釜鏂囦欢

```powershell
# 鍑嗗 URL 鍒楄〃
@(
    "https://example.com/file1.zip",
    "https://example.com/file2.zip",
    "https://example.com/file3.zip"
) | ForEach-Object {
    $name = Split-Path $_ -Leaf
    curl.exe -L -o "D:\Downloads\$name" $_
}
```

### 4. 鏂偣缁紶澶ф枃浠?
```powershell
# wget 鏂瑰紡 (-c 鍙傛暟)
wget.exe -c "https://example.com/huge-file.iso" -O "D:\Downloads\file.iso"
# Ctrl+C 涓柇鍚?鍐嶆鎵ц鍚屼竴鏉″懡浠ゅ彲鎺ョ潃涓?
# curl 鏂瑰紡
curl.exe -C - -o "D:\Downloads\file.iso" "https://example.com/huge-file.iso"
```

### 5. 鍙湅 HTTP 澶?
```powershell
# wget
wget.exe --spider "URL"

# curl
curl.exe -I -L "URL"
# 杈撳嚭:
# HTTP/1.1 200 OK
# Content-Type: application/octet-stream
# Content-Length: 279415162
```

### 6. POST 鏁版嵁鍒?API

```powershell
# wget
wget.exe --post-data="key=value&foo=bar" "https://api.example.com/endpoint"

# wget + JSON
wget.exe --header="Content-Type: application/json" `
    --post-data='{"key":"value"}' `
    "https://api.example.com/endpoint"

# curl
curl.exe -X POST -d '{"key":"value"}' -H "Content-Type: application/json" "URL"

# curl + 鏂囦欢 @-prefix
curl.exe -X POST -d @data.json -H "Content-Type: application/json" "URL"
```

### 7. 涓嬭浇骞舵樉绀鸿繘搴︽潯

```powershell
# wget 榛樿灏辨湁杩涘害鏉?wget.exe "URL" -O "file.zip"

# curl 鍔?# 绗﹀彿鏄剧ず杩涘害鏉?curl.exe -# -o "file.zip" "URL"
```

---

## 鍥涖€佸懡浠ゅ鐓ц〃

| 鍔熻兘 | GNU wget | GNU curl | PowerShell |
|------|----------|----------|------------|
| 涓嬭浇鏂囦欢 | `wget URL -O file` | `curl URL -o file` | `iwr URL -OutFile file` |
| 鏂偣缁紶 | `wget -c URL` | `curl -C - URL` | 鏃犲師鐢?|
| 浠呯湅澶?| `wget --spider URL` | `curl -I URL` | `iwr -Method Head URL` |
| POST | `wget --post-data=...` | `curl -X POST -d ...` | `irm -Method Post -Body ...` |
| 璺熼殢閲嶅畾鍚?| 榛樿 | `curl -L` | 榛樿 |
| 鐢ㄦ埛璁よ瘉 | `wget --user=... --password=...` | `curl -u user:pass` | `iwr -Credential ...` |
| 闄愰€?| `wget --limit-rate=200k` | `curl --limit-rate 200k` | 鏃?|
| 闈欓粯 | `wget -q` | `curl -s` | `iwr -Quiet` |

---

## 浜斻€佸父瑙侀敊璇?
### 閿欒 1: PowerShell 鍒悕鎷︽埅

```
wget: A parameter cannot be found that accepts argument '-O'
```

**瑙ｅ喅**:鐢?`wget.exe` 鎴栧湪 `$PROFILE` 绉婚櫎鍒悕銆?
### 閿欒 2: URL 寮曞彿闂

```
wget: URL not found
```

**瑙ｅ喅**:URL 蹇呴』鐢ㄥ弻寮曞彿,灏ゅ叾鍖呭惈 `+`銆乣.`銆佺壒娈婂瓧绗︽椂:
```powershell
wget.exe "https://example.com/file+v1.2.zip" -O "file.zip"
#                                  ^         ^
#                                  蹇呴』鐢ㄥ紩鍙?
```

### 閿欒 3: 鏂囦欢璺緞鏉冮檺

```
wget: Permission denied
```

**瑙ｅ喅**:杈撳嚭璺緞瑕佹湁鍐欐潈闄愩€備笉瑕佷笅鍒?`C:\Program Files\`銆乣C:\Windows\`銆?涓嬪埌 `D:\Downloads\` 鎴?`%USERPROFILE%\Downloads\`銆?
### 閿欒 4: 涓嬭浇鍒?99% 澶辫触

```
wget: Connection reset by peer
```

**瑙ｅ喅**:鐢?`-c` 鏂偣缁紶閲嶈瘯:
```powershell
wget.exe -c --tries=20 --timeout=120 "URL" -O "file"
```

### 閿欒 5: 涓嬭浇鍒颁竴鍗婂彂鐜版兂涓嬮敊鏂囦欢

`Ctrl + C` 涓柇,`rm` 鍒犳帀鍗婃垚鍝?浠庡ご鏉ャ€?
---

## 鍏€佷竴閿厤缃?鍐欏叆 $PROFILE)

```powershell
# 缂栬緫 profile
notepad $PROFILE
```

鍔犲叆:

```powershell
# === wget/curl 淇 ===
Remove-Item Alias:wget -Force -ErrorAction SilentlyContinue
Remove-Item Alias:curl -Force -ErrorAction SilentlyContinue

# === Git 浠ｇ悊蹇嵎 ===
function px-proxy "shae00O6_socks5" { git-proxy @args }
Set-Alias px "function:px-proxy" 2>$null  # 绠€鍖栬皟鐢?```

鏂板紑缁堢鍚?
- `wget URL -O file` 鐩存帴鐢熸晥
- `curl URL -o file` 鐩存帴鐢熸晥
- `px -h 127.0.0.1 -p 1080 -s` 涓€閿缃?git 浠ｇ悊

---

## 涓冦€侀獙璇佹柟娉?
```powershell
# 1. 楠岃瘉 wget 鐪熷疄鑳界敤
wget.exe --version
# 搴旇鏄剧ず GNU wget 1.20 涔嬬被

# 2. 楠岃瘉 PowerShell 鍒悕鐘舵€?Get-Command wget
# 濡傛灉鏄剧ず "Alias -> wget.exe" 璇存槑宸蹭慨澶?# 濡傛灉鏄剧ず "Alias -> Invoke-WebRequest" 璇存槑杩樻槸琚姭鎸?
# 3. 鐪熷疄娴嬭瘯
wget.exe "https://www.google.com" -O "test.html"
# 搴旇涓嬭浇 google 棣栭〉

Remove-Item "test.html"
```

---

## 鍏€佸弬鑰?
- [GNU wget 瀹樻柟鏂囨。](https://www.gnu.org/software/wget/manual/)
- [curl 瀹樻柟鏂囨。](https://curl.se/docs/)
- [PowerShell Invoke-WebRequest](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-webrequest)
- [GitHub 浠ｇ悊 gh-proxy.org](https://gh-proxy.org)

---

**閫傜敤**:Windows Terminal + PowerShell 5.1/7 + Windows 10/11


---

# git-proxy 鍧戯細-T 绁炵澶辨晥

> 鏄庢槑鍐欎簡 -T http 浣?git-proxy 涓嶆墽琛?set,鑰屾槸璺?test鈥斺€擯owerShell 鍙傛暟鍒悕澶у皬鍐欎笉鏁忔劅鐨勫潙銆?
---

## 涓€銆佺棁鐘?
`powershell
PS> git-proxy -h 198.51.100.10 -p 80 -T http -s
[INFO]  Testing current Git proxy connectivity...

[WARN]  No proxy currently set. Use -h <IP> -p <PORT> -s to set one.
`

鏈剰鏄€岃缃?HTTP 浠ｇ悊銆嶏紝浣嗚剼鏈疄闄呮墽琛岀殑鏄€屾祴璇曞綋鍓嶄唬鐞嗐€嶏紝鎵€浠ユ姤 "No proxy currently set"銆?
---

## 浜屻€佹牴鏈師鍥?
**PowerShell 鐨勫弬鏁板埆鍚嶆槸澶у皬鍐欎笉鏁忔劅鐨?*銆?
鑴氭湰閲屽悓鏃跺畾涔変簡:
`powershell
[Alias("t")][switch],           # -t 鈫?娴嬭瘯
[ValidateSet(...)][string] # -T 涔熸兂褰撳埆鍚?浣嗕細璺?-t 鍐茬獊
`

PowerShell 瑙ｆ瀽鏃?
- -T 鈫?璺?-t 鍖归厤(蹇界暐澶у皬鍐?鈫?瑙﹀彂 Test 妯″紡
- http 鈫?琚綋鎴?-p 鍚庣殑浣嶇疆鍙傛暟? 鈫?鐒跺悗灏辨姤 No proxy
- -s 鈫?Set 鏍囧織 鈫?浣嗗洜涓?Test 宸茬粡鍏堝尮閰?琚拷鐣?
---

## 涓夈€佷复鏃舵柟妗?鐢ㄥ叏鍚?
`powershell
# 鐢?-ProxyType 鍏ㄥ悕,涓嶇敤 -T 绠€鍐?git-proxy -h 198.51.100.10 -p 80 -ProxyType http -s
#                                  ^^^^^^^^
#                                  涓嶈鐢?-T
`

杩欐槸褰撳墠 v1.x 鐗堟湰鍞竴鑳界敤鐨勬柟寮忋€?
---

## 鍥涖€佹案涔呬慨澶?宸插悎鍏?v2.0)

鎶?-t 鏀瑰悕,閲婃斁 -T 缁?-ProxyType:

`powershell
# 鏃?
[Alias("t")][switch],

# 鏂?
[Alias("Test")][switch],
[Alias("T")][ValidateSet("http","https","socks5")][string] = "socks5",
`

### 杩佺Щ鏄犲皠

| 鏃у懡浠?| 鏂板懡浠?|
|--------|--------|
| git-proxy -t | git-proxy -Test |
| git-proxy -T http -s | git-proxy -T http -s (鐜板湪鑳界敤浜? |

### 楠岃瘉 v2.0

`powershell
PS> git-proxy -h 198.51.100.10 -p 80 -T http -s
[INFO]  Setting http proxy: http://198.51.100.10:80
[OK]    Proxy set successfully (effective immediately)

  Protocol    = http
  http.proxy  = http://198.51.100.10:80
  https.proxy = http://198.51.100.10:80

PS> git-proxy -Test
[INFO]  Testing current Git proxy connectivity...
[OK]    [REACHABLE] http://198.51.100.10:80
[OK]    [HTTP OK]   github.com reachable via proxy
`

---

## 浜斻€丳owerShell 鍒悕瑙勫垯璇﹁В

`powershell
# PowerShell 鍒悕 = 瀹屽叏涓嶅尯鍒嗗ぇ灏忓啓
[Alias("foo")]
[Alias("FOO")]
[Alias("Foo")]
# 杩欎笁涓畬鍏ㄤ竴鏍?鍚庡畾涔夌殑瑕嗙洊鍓嶉潰鐨?
# 鍛戒护琛屽弬鏁颁篃澶у皬鍐欎笉鏁忔劅
Get-Help -full
get-help -FULL
Get-help -Full
# 鍏ㄩ儴绛変环

# 鎵€浠?
# -h 鍜?-H 绛変环
# -ProxyType 鍜?-proxytype 绛変环
# -T 鍜?-t 绛変环(浣嗗彧鑳藉搴斾竴涓?Alias)
`

---

## 鍏€佽俯鍧戞暀璁?
| # | 鏁欒 |
|---|------|
| 1 | PowerShell 鍙傛暟鍒悕**姘歌繙涓嶈鍐茬獊**(鍗充娇鍙槸澶у皬鍐欏樊寮? |
| 2 | 鎯充繚鐣欎袱涓浉杩戝弬鏁扮殑绠€鍐欏埆鍚?**蹇呴』涓嶅悓闀垮害**(-t vs -T 涓嶈,-t vs -Test 鍙互) |
| 3 | 涓存椂瑙ｅ喅:鐢ㄥ叏鍚?(-ProxyType) |
| 4 | 鍐欏畬鑴氭湰鍚?**鎵嬪伐娴嬭瘯姣忕鍙傛暟缁勫悎**,鍒彧鐪嬭娉曢€氳繃 |
| 5 | 鐢?Get-Help script.ps1 -Full 鍙互鐪嬪埌鎵€鏈夊埆鍚?楠岃瘉鏃犲啿绐?|

---

## 涓冦€佺浉鍏充唬鐮佸樊寮?
### v1.x (鏈?bug)

`powershell
param(
    [Alias("h")][string],
    [Alias("p")][int],
    [ValidateSet("http","https","socks5")][string] = "socks5",  # 鈫?娌″埆鍚?    [Alias("t")][switch],                                              # 鈫?-t 鍗犵敤
    [Alias("s")][switch],
    [Alias("u")][switch],
    [Alias("c")][switch],
)
# 鐢ㄦ埛杈撳叆 -T http -s
# -T 琚В鏋愪负 -t 鈫?璺戞祴璇?# http 琚拷鐣?# -s 琚拷鐣?`

### v2.0 (宸蹭慨澶?

`powershell
param(
    [Alias("h")][string],
    [Alias("p")][int],
    [Alias("T")][ValidateSet("http","https","socks5")][string] = "socks5",  # 鈫?-T 鍙敤
    [Alias("Test")][switch],                                                 # 鈫?-Test,涓嶅啀鐢?-t
    [Alias("s")][switch],
    [Alias("u")][switch],
    [Alias("c")][switch],
)
# 鐢ㄦ埛杈撳叆 -T http -s
# -T 瑙ｆ瀽涓?ProxyType
# http 瑙ｆ瀽涓?ProxyType 鐨勫€?# -s 瑙﹀彂 Set
# 瀹岀編宸ヤ綔 鉁?`

---

**鎺ㄩ€佸埌 GitHub**: https://github.com/yao1987825/git-proxy/blob/main/windows/git-proxy.ps1


---

# HTTP 浠ｇ悊鏃犳硶鎺ㄩ€?HTTPS 浠撳簱鐨勯棶棰?
> git-proxy -Test 閮介€氳繃,浣?git push 鎶?CONNECT tunnel failed, response 400銆?
---

## 涓€銆佺棁鐘?
`powershell
PS> git-proxy -Test
[OK]  [REACHABLE]  http://198.51.100.10:80
[OK]  [HTTP OK]    github.com reachable via proxy

PS> git push -u origin main
fatal: unable to access 'https://github.com/...':
  CONNECT tunnel failed, response 400
`

git-proxy -Test 鏄庢槑閫氳繃浜?浣?git push 杩樻槸澶辫触銆?
---

## 浜屻€佹牴鍥?
git-proxy -Test 鍙祴浜嗕唬鐞嗙殑 **HTTP 杞彂鑳藉姏**,娌℃祴 **HTTPS CONNECT 闅ч亾鑳藉姏**銆?
Git 鎺ㄩ€?HTTPS 浠撳簱鏃跺彂鐨勬槸:
`
CONNECT github.com:443 HTTP/1.1
`

浠ｇ悊濡傛灉鍙敮鎸?HTTP 杞彂(鏅€?HTTP GET/POST),**涓嶆敮鎸?HTTPS 闅ч亾**,灏变細杩斿洖 400 Bad Request銆?
### 浣犺繖涓唬鐞嗙殑鍏蜂綋琛ㄧ幇

`ash
$ curl -v -x "http://198.51.100.10:80" "https://github.com"
> CONNECT github.com:443 HTTP/1.1
> Host: github.com:443
>
< HTTP/1.1 400 Bad Request     鈫?浠ｇ悊鎷掔粷寤洪毀閬?< Server: nginx/1.22.0
`

---

## 涓夈€佽В鍐虫柟妗?
### 鏂规 1(鏈€鎺ㄨ崘):鎹?SOCKS5 浠ｇ悊

SOCKS5 鍗忚鏀寔浠讳綍 TCP 娴侀噺,涓嶅瓨鍦?HTTPS 闅ч亾闂銆?
`powershell
git-proxy -u
git-proxy -h 127.0.0.1 -p 1080 -s        # 鏈湴 SOCKS5
# 鎴栬€?git-proxy -h 浣犵殑SOCKS5鏈嶅姟鍣?-p 1080 -s
`

甯歌鐨?SOCKS5 鏉ユ簮:
- Clash Verge / Clash for Windows: 127.0.0.1:7891
- V2RayN: 127.0.0.1:10808
- SSH 鍔ㄦ€佽浆鍙? ssh -D 1080 user@server 鍚庣敤 127.0.0.1:1080

### 鏂规 2:鐢ㄦ柊澧炵殑 -HttpOnly 閫夐」(浠?HTTP)

濡傛灉浣犵殑浠ｇ悊鍙敮鎸?HTTP,**涓斾綘鍙敤 HTTP 鍗忚鐨?git 浠撳簱**(澶ч儴鍒?GitHub 浠撳簱鏄?HTTPS,杩欐潯璺熀鏈蛋涓嶉€?:

`powershell
git-proxy -u
git-proxy -h 198.51.100.10 -p 80 -T http -HttpOnly -s
#                                       ^^^^^^^^
#                                       鍙 http.proxy, 涓嶈 https.proxy
`

鏁堟灉:
`
http.proxy  = http://198.51.100.10:80
https.proxy = (绌?
`

**浣嗗疄闄呮晥鏋滄湁闄?*:GitHub/GitLab 閮藉己鍒?HTTPS,杩欎釜閫夐」鍙槸缁曞紑 https.proxy 璁剧疆,瀹為檯 push 鏃惰繕鏄細灏濊瘯 HTTPS 鈫?杩樻槸浼氬け璐ャ€?
### 鏂规 3:鎹㈣兘鏀寔 HTTPS 鐨?HTTP 浠ｇ悊

鏈変簺浠ｇ悊(姣斿 Squid 閰嶇疆濂界殑銆丆addy reverse_proxy銆乶ginx stream)鏀寔 HTTPS CONNECT銆傝鐪嬩綘鐨?198.51.100.10:80 鍚庣鏄粈涔堛€?
---

## 鍥涖€佹敼杩涚増 -Test(鏇翠弗鏍肩殑妫€娴?

v2.1 鏀硅繘浜?-Test,浼氱湡姝ｆ祴璇?HTTPS CONNECT:

`
PS> git-proxy -Test
[INFO]  Testing current Git proxy connectivity...

  Testing http.proxy = http://198.51.100.10:80 ...
[OK]    [REACHABLE]  http://198.51.100.10:80
[OK]    [HTTP OK]    github.com reachable via proxy   鈫?鏅€?HTTP OK

  Testing https.proxy = http://198.51.100.10:80 ...
[OK]    [REACHABLE]  http://198.51.100.10:80
[WARN]  [HTTPS FAIL] github.com NOT reachable via HTTPS tunnel  鈫?鐪熼棶棰樺湪杩?[WARN]  Proxy is HTTP-only, won't work for HTTPS git repos
[WARN]  Use SOCKS5 proxy instead, or add -HttpOnly flag
`

濡傛灉浣犵湅鍒?[HTTPS FAIL],灏辨槸杩欎釜闂,蹇呴』鎹?SOCKS5 浠ｇ悊銆?
---

## 浜斻€佺浉鍏?git 鍛戒护

`ash
# 鏌ョ湅褰撳墠 git 浠ｇ悊
git config --global --get http.proxy
git config --global --get https.proxy

# 娴嬭瘯涓嶉€氳繃浠ｇ悊鑳戒笉鑳借繛 github
git -c http.proxy= -c https.proxy= clone https://github.com/octocat/Hello-World.git /tmp/test

# 娴嬭瘯鍙€氳繃 http.proxy(涓嶈蛋 https.proxy)
git -c https.proxy= clone https://github.com/octocat/Hello-World.git /tmp/test
`

---

## 鍏€佹暀璁?
| # | 鏁欒 |
|---|------|
| 1 | HTTP 浠ｇ悊 鈮?HTTPS 浠ｇ悊銆侶TTP 杞彂鍜?HTTPS 闅ч亾鏄袱鐮佷簨 |
| 2 | 鍥藉唴寰堝 HTTP 浠ｇ悊(灏ゅ叾鏄?CDN 鍔犻€熺殑)鍙敮鎸?HTTP 杞彂 |
| 3 | git-proxy -Test 鍦?v2.0 鍙祴浜?HTTP,琚繖涓?case 鎵撲簡鑴?|
| 4 | 涓€鍔虫案閫?**鐢?SOCKS5 浠ｇ悊** |
| 5 | 濡傛灉鍙湁 HTTP 浠ｇ悊,-HttpOnly 鏄?workaround,涓嶆槸 solution |

---

**鐩稿叧浠ｇ爜**: git-proxy.ps1 v2.1(宸插姞 -HttpOnly 鍙傛暟 + 鏀硅繘鐨?-Test 娴?HTTPS)

**GitHub**: https://github.com/yao1987825/windows-terminal


---

# IPv4 鏍￠獙涓嶄弗 + 鎷煎啓閿欒瀵艰嚧鍋囬槾鎬?
> git-proxy -Test 鎶?[UNREACHABLE],浣嗗叾瀹炲彧鏄?IP 鍐欓敊浜嗐€?
---

## 涓€銆佺棁鐘?
`powershell
PS> git-proxy -h 203.0.113.999 -p 80 -s
[INFO]  Setting socks5 proxy: socks5://203.0.113.999:80
[OK]    Proxy set successfully (effective immediately)

PS> git-proxy -Test
[INFO]  Testing current Git proxy connectivity...
  Testing http.proxy = socks5://203.0.113.999:80 ...
[WARN]    [UNREACHABLE] socks5://203.0.113.999:80
`

鐢ㄦ埛鍥版儜:鏄庢槑鑴氭湰璇?"set successfully",涓轰粈涔?-Test 鍙堣涓嶅彲杈?

---

## 浜屻€佹牴鍥?鍙屽眰 bug)

### Bug 1: 鎷煎啓閿欒

鐢ㄦ埛杈撳叆浜?203.0.113.999,浣?IPv4 鍦板潃姣忎釜娈垫渶澶у彧鑳?255,鎵€浠?828 鏄棤鏁堢殑銆?
> 鐪熷疄鎰忓浘搴旇鏄?203.0.113.99(鍙兘鏄墜鎶栧鎸変簡涓€涓?8)銆?
### Bug 2: 鑴氭湰 IP 鏍￠獙涓嶄弗

git-proxy 鐨?IPv4 姝ｅ垯鍙牎楠?*浣嶆暟**(1-3 浣嶆暟瀛?,娌℃牎楠?*鏁板€?*:
`powershell
 = '^(\d{1,3}\.){3}\d{1,3}$'
# 杩欐潯浼氶€氳繃:  203.0.113.999 (鍥犱负姣忔閮芥槸 1-3 浣嶆暟瀛?
# 杩欐潯涔熶細閫氳繃: 999.999.999.999 (鑽掑攼浣嗙鍚堟鍒?
`

鎵€浠ヨ剼鏈棤鑴戝湴鎶婃棤鏁?IP 鍐欒繘浜?~/.gitconfig,鐒跺悗 -Test 璇曞浘杩炰竴涓笉瀛樺湪鐨?IP,鑷劧 UNREACHABLE銆?
---

## 涓夈€佷慨澶?
### Windows 鐗?(git-proxy.ps1)

鏂板 IP 娈垫暟鍊兼牎楠?

`powershell
if ( -match ) {
    # Looks like IPv4 鈥?verify each octet is 0-255
     =  -split '\.'
     = True
    foreach ( in ) {
         = 0
        if (-not [int]::TryParse(, [ref])) {  = False; break }
        if ( -lt 0 -or  -gt 255) {  = False; break }
    }
    if (-not ) {
        Write-Err "Invalid IPv4 address:  (each octet must be 0-255)"
        exit 1
    }
}
`

### Debian 鐗?(git-proxy.sh)

`ash
if [[ "System.Management.Automation.Internal.Host.InternalHost" =~  ]]; then
    local IFS='.'
    read -ra octets <<< "System.Management.Automation.Internal.Host.InternalHost"
    for octet in ""; do
        if (( octet < 0 || octet > 255 )); then
            err "Invalid IPv4 address: System.Management.Automation.Internal.Host.InternalHost (each octet must be 0-255)"
            exit 1
        fi
    done
fi
`

---

## 鍥涖€侀獙璇佷慨澶?
`
PS> git-proxy -h 203.0.113.999 -p 80 -s
[ERROR] Invalid IPv4 address: 203.0.113.999 (each octet must be 0-255)
                                      鉁?鐜板湪鑳芥嫤浣?
PS> git-proxy -h 1.1.1.256 -p 80 -s
[ERROR] Invalid IPv4 address: 1.1.1.256 (each octet must be 0-255)
                                      鉁?杈圭晫鍊?256 鎷掔粷

PS> git-proxy -h 255.255.255.255 -p 80 -s
[INFO]  Setting socks5 proxy: socks5://255.255.255.255:80
[OK]    Proxy set successfully
                                      鉁?杈圭晫鍊?255 鎺ュ彈

PS> git-proxy -h 203.0.113.99 -p 80 -s
[INFO]  Setting socks5 proxy: socks5://203.0.113.99:80
[OK]    Proxy set successfully
                                      鉁?姝ｇ‘ IP 閫氳繃

PS> git-proxy -h proxy.example.com -p 80 -s
[INFO]  Setting socks5 proxy: socks5://proxy.example.com:80
[OK]    Proxy set successfully
                                      鉁?鍩熷悕涔熼€氳繃
`

---

## 浜斻€佹暀璁?
| # | 鏁欒 |
|---|------|
| 1 | 姝ｅ垯琛ㄨ揪寮忔牎楠?*姘歌繙瑕佷簩娆＄‘璁よ涔?*鈥斺€斾綅鏁板浜嗕笉浠ｈ〃鏁板€煎 |
| 2 | IPv4 鏍￠獙蹇呴』鎷嗘鍚?*閫愭  -255 鏍￠獙**,涓嶈兘鍙鏌ヤ綅鏁?|
| 3 | 鐢ㄦ埛鎷奸敊 IP 鏄父浜?**鎶ラ敊淇℃伅瑕佹槑纭?*: "鏃犳晥 IPv4 鍦板潃" 姣?"杩炰笉涓? 鏇存湁鐢?|
| 4 | 鍦?set 鏃跺氨鏍￠獙澶辫触,姣?set 鎴愬姛浣?test 澶辫触"鐨勪簩娈垫姤閿欐洿娓呮櫚 |
| 5 | 杈圭晫鍊兼祴璇? 銆?55銆?256銆?999 閮借瑕嗙洊 |

---

## 鍏€両Pv4 鍦板潃甯歌瘑

| 绫诲瀷 | 鑼冨洿 | 璇存槑 |
|------|------|------|
| 绉佹湁 | 10.0.0.0/8 | 澶у瀷鍐呯綉 |
| 绉佹湁 | 172.16.0.0/12 | 涓瀷鍐呯綉 |
| 绉佹湁 | 192.168.0.0/16 | 瀹跺涵/灏忓瀷鍐呯綉 |
| 鐜洖 | 127.0.0.0/8 | localhost |
| 閾捐矾鏈湴 | 169.254.0.0/16 | DHCP 澶辫触鏃惰嚜鍔ㄥ垎閰?|
| 鍏綉 | 鍏朵粬 | 闇€ ISP 鍒嗛厤 |

浠讳綍涓€娈甸兘蹇呴』鍦?**0-255** 涔嬮棿銆?
---

**鎺ㄩ€佸埌 GitHub**: https://github.com/yao1987825/windows-terminal/blob/main/git-proxy.ps1
