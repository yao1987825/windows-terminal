# Windows Terminal 实战手册

> 📦 一站式 Windows Terminal 部署 + Git 代理管理解决方案

[![GitHub](https://img.shields.io/badge/GitHub-yao1987825-blue)](https://github.com/yao1987825)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2F11-blue)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue)](https://github.com/PowerShell/PowerShell)

---

## 📖 项目简介

本仓库记录了从零开始部署 **Windows Terminal** 的完整过程，包括：

- ✅ 离线环境下的 MSIX 安装（含框架依赖处理）
- ✅ Chocolatey 安装踩坑与替代方案
- ✅ 系统恶意软件清理实战（DirectX 修复工具 / 360 安全卫士 / 爱奇艺）
- ✅ Git SOCKS5 代理一键管理脚本
- ✅ 全部错误码、解决思路、最佳实践

适合 **国内网络环境**、**离线部署**、**企业内网** 的 Windows 用户。

---

## 🎯 核心特性

### 1. Windows Terminal 安装
- 离线 MSIX Bundle 安装方案（PreinstallKit）
- Chocolatey 失败的替代姿势
- 完整错误处理与排查清单

### 2. Git SOCKS5 代理管理
- 一行命令设置/撤销代理
- 全局调用（任意目录、任意终端）
- 自动连通性测试

### 3. 恶意软件清除实战
- 浏览器劫持型广告软件
- 内核级自我保护的安全软件（360）
- 多组件捆绑安装的应用（爱奇艺）

---

## 📂 文件说明

| 文件 | 说明 |
|------|------|
| [`INSTALL.md`](./INSTALL.md) | **主文档** —— Windows Terminal 完整安装、使用指南、恶意软件清除记录 |
| [`git-proxy.ps1`](./git-proxy.ps1) | Git SOCKS5 代理管理脚本（PowerShell 核心逻辑） |
| [`git-proxy.cmd`](./git-proxy.cmd) | CMD 包装器，加入 PATH 后全局可用 |
| [`.gitignore`](./.gitignore) | Git 忽略规则（排除敏感文件、下载包） |

---

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/yao1987825/windows-terminal.git
cd windows-terminal
```

### 2. 安装 Windows Terminal

详见 [`INSTALL.md` 第 1-8 章](./INSTALL.md)。

**核心步骤**：
1. 下载 GitHub releases 的 `*_Windows10_PreinstallKit.zip`
2. 先装 `Microsoft.UI.Xaml.2.8_x64.appx`
3. 再装 `.msixbundle`
4. 验证 `wt` 命令可用

### 3. 使用 Git 代理脚本

#### 方式 1：全局命令（推荐）

把 `D:\Windows_Terminal` 加入 PATH 后，任意目录可用：

```powershell
git-proxy -h 127.0.0.1 -p 1080 -s    # 设置代理
git-proxy -u                          # 撤销代理
git-proxy -c                          # 查看状态
```

#### 方式 2：脚本目录运行

```powershell
cd D:\Windows_Terminal
.\git-proxy.ps1 -h 127.0.0.1 -p 1080 -s
```

---

## 📖 文档目录（INSTALL.md）

```
一、环境信息
二、目标
三、安装过程
    ├─ 方案 A：Chocolatey 安装（失败）
    └─ 方案 B：下载官方 MSIX Bundle + 依赖（成功）
四、最终结果
五、所有错误汇总（10 条）
六、踩坑教训
七、关键命令速查
八、参考链接
九-十六、Windows Terminal 使用指南
    ├─ 启动方式
    ├─ settings.json 配置
    ├─ 必备快捷键
    ├─ 进阶玩法
    ├─ 常见问题
    ├─ 性能与调试
    └─ 推荐生态
恶意软件清除记录
    ├─ DirectX 修复工具
    └─ 360 + 爱奇艺 彻底清除
Git 代理管理脚本
全局调用配置
```

---

## 🛠️ 系统要求

- **OS**: Windows 10 1809+ 或 Windows 11
- **PowerShell**: 5.1+（Win10 自带）/ PowerShell 7（推荐）
- **Git**: 2.30+（Win10 自带的 OpenSSH 即可）
- **权限**: 管理员权限（用于安装 MSIX 包、清理恶意软件）

---

## ⚠️ 重要安全提示

本仓库**不包含任何敏感信息**（token、密钥等）。.gitignore 已排除：
- `.env` / `*.key` / `*.pem`
- `secrets.*` / `config.local.*`
- 所有下载的安装包

如果你 fork 此仓库并打算提交个人配置，请检查不要提交：
- GitHub Personal Access Token
- SSH 私钥
- 服务器密码 / API key

---

## 🤝 贡献指南

欢迎提交 PR！建议贡献方向：

- 📝 补充更多 Windows Terminal 配置示例
- 🐛 记录其他安装方式的踩坑
- 🔧 增强 git-proxy 脚本功能（如：多 profile、HTTP 代理支持）
- 🛡️ 补充恶意软件清除案例

### 提交规范

- 提交前确保脚本语法通过 PowerShell Parser 检查
- 大改动请先开 issue 讨论
- 文档改动请同步更新 INSTALL.md 的目录

---

## 📜 许可证

MIT License

```
MIT License

Copyright (c) 2026 yao1987825

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🌟 Star History

如果这个项目帮到你，欢迎点 ⭐ Star！

---

## 📮 联系方式

- GitHub: [@yao1987825](https://github.com/yao1987825)
- Issues: [提交 Issue](https://github.com/yao1987825/windows-terminal/issues)

---

**最后更新**：2026-09-17
**适用版本**：Windows Terminal 1.24.11911.0 / PowerShell 5.1+