# NixOS Config

这是一个使用 NixOS Flake、Home Manager 和 agenix 管理的声明式系统配置仓库。配置面向多台 NixOS 主机以及一个非 NixOS 环境中的独立 Home Manager 用户环境。

仓库以 `flake.nix` 为统一入口，通过 `lib.nix` 中的 `mkHost` 组装主机配置。公共能力沉淀在 `modules/` 中，机器相关配置集中放在 `hosts/` 下。

## 技术栈

- NixOS 与 Flake
- Home Manager
- Disko
- agenix
- devenv
- `nixos-25.11` 与少量 `nixpkgs-unstable` 软件包

## 仓库结构

```text
.
├── flake.nix          # Flake 入口：inputs、NixOS 主机和 Home Manager 配置
├── flake.lock         # Flake 输入锁文件
├── lib.nix            # mkHost：统一组装主机、disko 和 Home Manager
├── justfile           # 部署、更新、清理和密钥管理命令
├── devenv.nix         # 开发工具与 nixfmt-rfc-style git hook
├── devenv.yaml
├── devenv.lock
├── hosts/             # 各主机的硬件、网络、用户和专用服务配置
├── modules/           # 可复用的 NixOS 与 Home Manager 模块
└── secrets/           # agenix 密钥声明与加密后的 .age 文件
```

### 主机配置

常规 NixOS 主机以 `hosts/<host>/default.nix` 为入口：

```text
hosts/<host>/
├── default.nix                  # 主机入口
├── hardware/
│   ├── default.nix
│   ├── disk.nix                 # disko 磁盘布局
│   ├── filesystem.nix
│   ├── gpu.nix                  # 部分主机使用
│   └── hardware-configuration.nix
├── network.nix                  # 或 network/ 目录
├── user.nix                     # NixOS 用户配置
└── users/<username>.nix         # Home Manager 用户入口
```

### 公共模块

```text
modules/
├── nixos/
│   ├── default.nix              # 基础系统模块聚合入口
│   ├── boot.nix
│   ├── fhs.nix
│   ├── home-manager.nix
│   ├── i18n.nix
│   ├── misc.nix
│   ├── nix.nix
│   ├── pkgs.nix
│   ├── ssh.nix
│   └── extraServices/
│       ├── desktop/             # 桌面、音频、字体、蓝牙和安全配置
│       ├── agenix.nix
│       ├── gaming.nix
│       ├── jellyfin.nix
│       ├── mihomo.nix
│       ├── nextcloud.nix
│       ├── tailscale.nix
│       └── virtualization.nix
└── home-manager/
    ├── common/                  # CLI、shell、Helix、Git、Zellij 等
    ├── gui/                     # GNOME、Hyprland、Waybar、SwayNC、输入法等
    ├── extraServices/           # openlist、rclone
    ├── scripts/                 # 桌面与日常脚本
    ├── ghostty.nix
    ├── llm-agents-package.nix
    └── xdg-mimes.nix
```

## 主机说明

| Flake 输出 | 配置目录 | 用户 | 主要用途 |
| --- | --- | --- | --- |
| `brain-holder` | `hosts/brain-holder/` | `asen` | 日常桌面、开发、游戏和本地服务 |
| `home-server` | `hosts/home-server/` | `wanglei` | 家用服务器、局域网网关和容器宿主机 |
| `blue-10700` | `hosts/blue-10700/` | `asen` | 固定地址的额外服务节点 |
| `rainyun` | `hosts/rain-cloud/` | `root` | 远程 Tailscale DERP 节点 |
| `homeConfigurations.root` | `hosts/nixos-in-docker/root.nix` | `root` | 非 NixOS 环境中的 Home Manager 配置 |

### `brain-holder`

日常使用的桌面主机，导入完整的 `modules/nixos/extraServices/` 服务集合。

主要功能：

- CachyOS LTS 内核。
- 桌面环境、PipeWire、字体、蓝牙、Wayland 和 dconf。
- Home Manager 图形环境：Hyprland、Waybar、SwayNC、输入法、Ghostty 和常用脚本。
- Steam、Gamescope、Protontricks、GameMode 和低延迟 PipeWire 游戏优化。
- Docker、libvirt、QEMU、virt-manager、SPICE 和虚拟 TPM。
- Tailscale 与 nftables 防火墙。
- Jellyfin 媒体服务。
- NTFS 文件系统支持。
- agenix 密钥解密支持。
- Nextcloud 目前仍随完整服务集合导入，后续计划停用。

部署命令：

```bash
just deploy-brain
```

### `home-server`

家用服务器，同时作为局域网出口和 DHCP/DNS 服务节点。

主要功能：

- 双网口网络配置：WAN 接口负责外网连接，LAN 接口使用 `192.168.50.1/24`。
- NAT 转发，为 LAN 内设备提供外网访问。
- dnsmasq DHCP 与 DNS 服务，地址池为 `192.168.50.100` 至 `192.168.50.200`。
- Docker 容器运行环境。
- Tailscale 与 nftables 防火墙。
- Mihomo 透明代理，订阅地址通过 agenix 解密后生成运行时配置。
- `wanglei` 用户的公共 Home Manager 环境。

部署命令：

```bash
just deploy-server
```

### `blue-10700`

额外的 NixOS 服务节点，使用固定局域网地址。

主要功能：

- CachyOS Server LTO 内核。
- 固定地址 `192.168.137.16/24`，默认网关为 `192.168.137.1`。
- Docker 容器运行环境。
- Tailscale 与 nftables 防火墙。
- Mihomo 透明代理，订阅地址通过 agenix 管理。
- `asen` 用户的公共 Home Manager 与 LLM agent 软件包环境。

部署命令：

```bash
just deploy-blue-10700
```

### `rainyun`

部署在远程云主机上的轻量节点。Flake 输出名为 `rainyun`，配置目录为 `hosts/rain-cloud/`，系统 hostname 为 `RainYun`。

主要功能：

- Tailscale 与 nftables 防火墙。
- 自托管 DERP 服务。
- DERP 客户端校验。
- 自动生成用于 DERP 的自签名 IP 证书。
- 开放 DERP TCP 端口和 STUN UDP 端口。
- SSH root 密钥登录。

远程部署命令：

```bash
just deploy-remote
```

### `homeConfigurations.root`

用于非 NixOS 环境中的独立 Home Manager 配置，例如容器或已有 Linux 系统。

主要功能：

- 公共 CLI、shell、Helix、Git 和 Zellij 配置。
- LLM agent 软件包环境。

应用命令：

```bash
just deploy-docker
```

## 开发环境

进入 devenv 环境：

```bash
devenv shell
```

`devenv.nix` 提供 `nixfmt-rfc-style` 和对应 git hook。格式化 Nix 文件：

```bash
nixfmt <files...>
```

## 常用命令

| 命令 | 说明 |
| --- | --- |
| `just deploy-brain` | 部署 `brain-holder` |
| `just deploy-server` | 部署 `home-server` |
| `just deploy-blue-10700` | 部署 `blue-10700` |
| `just deploy-remote` | 远程部署 `rainyun` |
| `just deploy-docker` | 应用独立 `root` Home Manager 配置 |
| `just up [input]` | 更新全部或指定 Flake 输入 |
| `just history` | 查看系统 profile 历史 |
| `just clean` | 清理旧系统 generations |
| `just gc` | 清理未使用的 Nix store 内容 |
| `just secret-edit <name>` | 编辑 agenix 密钥 |
| `just secret-rekey` | 重新加密全部 agenix 密钥 |

## 密钥管理

敏感信息使用 agenix 管理：

- `secrets/secrets.nix` 声明主机公钥和加密文件。
- `secrets/*.age` 保存加密后的内容。
- 运行时配置通过 `config.age.secrets.<name>.path` 读取解密文件。

编辑密钥时使用：

```bash
just secret-edit <name-without-age-suffix>
```
