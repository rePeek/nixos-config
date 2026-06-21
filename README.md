# NixOS Config

这是一个使用 NixOS Flake、Home Manager 和 agenix 管理的声明式系统配置仓库。配置面向多台 NixOS 主机以及一个非 NixOS 环境中的独立 Home Manager 用户环境。

仓库以 `flake.nix` 为统一入口，通过 `lib.nix` 中的 `mkHost` 组装主机配置。公共能力沉淀在 `modules/` 中，机器相关配置集中放在 `hosts/` 下。

## 技术栈

- NixOS 与 Flake
- Home Manager
- Disko
- agenix
- devenv
- `nixos-unstable`

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
│   ├── filesystem.nix           # 主机专属磁盘布局、挂载点和 UUID
│   └── hardware-configuration.nix
└── network.nix                  # 或 network/ 目录
```

### 公共模块

```text
modules/
├── nixos/
│   ├── core/                    # 所有 NixOS 主机共享的基础模块
│   │   ├── default.nix
│   │   ├── boot.nix             # 通用默认值与 custom.boot 选项
│   │   ├── fonts.nix            # 桌面和服务器共用的基础字体
│   │   ├── i18n.nix
│   │   ├── nix.nix
│   │   ├── packages.nix
│   │   ├── security.nix
│   │   ├── ssh.nix
│   │   ├── system.nix
│   │   ├── power.nix
│   │   ├── kernel.nix
│   │   └── tailscale.nix
│   ├── server/                  # 服务器 NixOS profile 入口，包含系统用户和通用服务
│   │   ├── default.nix
│   │   ├── agenix.nix
│   │   ├── cli-proxy-api.nix
│   │   ├── fhs.nix
│   │   ├── mihomo.nix
│   │   └── virtualization.nix
│   ├── desktop/                 # 桌面 NixOS profile 入口，通过 custom.desktop.* 开启桌面能力
│   │   ├── amd.nix
│   │   ├── avatar.nix
│   │   ├── gaming.nix
│   │   ├── nvidia.nix
│   │   ├── core/                # 图形、音频、蓝牙、输入法、字体、基础工具和 Wayland portal
│   │   ├── shell/               # DMS shell、Hyprland session 和 greeter
│   │   ├── terminal.nix
│   │   ├── theme.nix
│   │   ├── default.nix
│   │   └── README.md
│   └── home-manager.nix         # 加载用户 Home Manager role 并应用主机级 custom.home.users.* 默认值
├── user/                        # 可复用用户定义，按用户同时放 NixOS 和 Home Manager 侧配置
│   └── asen/
│       ├── nixos.nix
│       └── home.nix
└── home-manager/
    ├── server/                  # server 用户环境，CLI、shell、Helix、Git、Zellij、LLM agents 等
    ├── desktop/                 # desktop 用户环境，继承 server
    │   ├── dms/                 # DMS 和 Hyprland 会话配置
    │   ├── browser.nix          # 默认应用、用户应用配置和 XDG MIME 关联等平铺模块
    │   └── ...
```

每台 NixOS 主机的 `hosts/<host>/hardware/` 保存机器事实，例如自动生成的硬件配置、磁盘布局、UUID、initrd 驱动、固件开关，以及按需导入的 `nixos-hardware` 机型或通用硬件模块。主机入口导入 `modules/nixos/core`、`server` 或 `desktop` 表达机器角色；可复用系统能力通过主机入口中的 `custom.core.*`、`custom.server.*` 和 `custom.desktop.*` 声明。core profile 是无个人用户的最小主机层，并默认启用 Tailscale；server profile 在 core 上增加系统用户和通用服务选项；desktop profile 在 server 上默认启用图形、音频、蓝牙、输入法和基础桌面工具。启动模式使用 `custom.boot.mode = "uefi"` 或 `"bios"`；公共 boot 模块负责生成对应的 systemd-boot 或 GRUB 配置。

## `custom` 配置

`custom.*` 是本仓库的 profile 和意图层，用来把主机配置简化为“启用什么能力、采用什么角色或模式”。模块内部会把这些 profile 展开为 NixOS 和 Home Manager 的原生配置；主机文件只保留 profile 选择和无法抽象的机器事实，例如 PCI Bus ID、UUID、hostname、用户名和端口。

当前主要命名空间：

- `custom.boot.*`：主机启动 profile。当前包括 `custom.boot.mode = "uefi" | "bios"` 和 BIOS 模式下可选的 `custom.boot.grubDevice`。
- `custom.core.*`：所有主机共享的基础能力。当前包括 `power.profile` 和 `kernel.cachyos`。
- `custom.desktop.nvidia.driver.enable`：本仓库的 NVIDIA 驱动默认策略，包括 DRM framebuffer、open module、settings、latest driver、modesetting 和基础电源管理。
- `custom.desktop.nvidia.compute.enable`：NVIDIA 计算和容器集成能力，主机硬件层仍负责 `nixos-hardware` 导入、显示拓扑和 Bus ID 等机器事实。
- `custom.core.power.profile`：主机电源策略，当前包括 `"performance"` 和 `"efficiency"`。
- `custom.server.virtualization.*`：虚拟化能力，当前包括 `docker`、`libvirtd`、`qemuUserAarch64` 和 `kvm.cpu = null | "intel" | "amd"`。
- `custom.server.*`：服务器侧通用能力。当前包括 `virtualization`、`agenix`、`fhs`、`mihomo` 和 `cli-proxy-api`。
- `custom.server.llm-agents.enable`：Home Manager server role 中的 LLM agent CLI 包集合，默认启用。
- `custom.users.*`：系统用户 profile。主机通过 `custom.users.enabled` 启用用户，并通过对应用户子选项追加主机专属 groups 或 SSH authorized keys。
- `custom.home.users.*`：主机级 Home Manager 默认值。用于声明某台主机上某个用户的 Home Manager role（`server` 或 `desktop`）、额外用户包、Hyprland 输出规则和 Firefox 代理等覆盖项。
- `custom.core.tailscale.*`：所有主机默认启用的 Tailscale 基础网络能力，可按主机覆盖 exit node 和 DNS 行为。
- `custom.desktop.*`：桌面 profile 和桌面体验中的可选能力。NixOS 侧 `enable` 启用桌面基础配置，基础图形、音频、蓝牙、输入法和桌面工具由 `modules/nixos/desktop/core/` 固定提供；子项保留 `amd`、`nvidia`、`gaming`、`shell`、`theme`、`terminal` 和 `avatar` 等需要主机或用户选择的能力。Home Manager 侧 `custom.desktop.defaults.*` 应用默认应用、用户应用配置和 XDG MIME 关联。
- `custom.ssh.sharedAuthorizedKeys`：共享 SSH 公钥集合，供主机用户配置复用。

## 主机说明

| Flake 输出 | 配置目录 | 用户 | 主要用途 |
| --- | --- | --- | --- |
| `brain-holder` | `hosts/brain-holder/` | `asen` | 日常桌面、开发、游戏和本地服务 |
| `home-server` | `hosts/home-server/` | 无 | 家用服务器、局域网网关和容器宿主机 |
| `blue-10700` | `hosts/blue-10700/` | `asen` | 固定地址的额外服务节点 |
| `rainyun` | `hosts/rain-cloud/` | `root` | 远程 Tailscale DERP 节点 |
| `homeConfigurations.root` | `hosts/nixos-in-docker/root.nix` | `root` | 非 NixOS 环境中的 Home Manager 配置 |

### `brain-holder`

日常使用的桌面主机，导入 `modules/nixos/desktop/`，并按需启用 server 层服务。

主要功能：

- CachyOS LTS 内核。
- 桌面环境、PipeWire、字体、蓝牙、Wayland 和 dconf。
- Home Manager 图形环境：Hyprland、Waybar、SwayNC、输入法、Ghostty 和常用脚本。
- Steam、Gamescope、Protontricks、GameMode 和低延迟 PipeWire 游戏优化。
- Docker、libvirt、QEMU、virt-manager、SPICE 和虚拟 TPM。
- Tailscale 与 nftables 防火墙。
- NTFS 文件系统支持。
- agenix 密钥解密支持。

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
- 无个人 Home Manager 用户。
- 通过共享 SSH 公钥进行 root key-only 登录。

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

## Flake 构建失败排查

如果遇到 flake 构建下载依赖失败、缓存连接慢或命中率低，可以在 `flake.nix` 里临时增加 `nixConfig` 使用额外二进制缓存。

注意：`nixConfig` 只影响当前 flake 的 Nix 命令行为，不会自动写入系统级 `nix.settings`。

```nix
# the nixConfig here only affects the flake itself, not the system configuration!
# for more information, see:
#     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
nixConfig = {
  # substituers will be appended to the default substituters when fetching packages
  extra-substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://cache.numtide.com"
    "https://attic.xuyh0120.win/lantian"
  ];
  extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
  ];
};
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
