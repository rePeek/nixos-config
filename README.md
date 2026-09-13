# NixOS Config

这是一个使用 NixOS Flake、Home Manager、Disko 和 agenix 管理的声明式多主机配置仓库。`flake.nix` 是唯一入口，`lib.nix` 中的 `mkHost` 负责组装 NixOS、Disko 和（按需启用的）Home Manager。

## 获取仓库

仓库包含本地 Flake input 所需的 Git 子模块。首次克隆时应递归获取：

```bash
git clone --recurse-submodules <repository>
```

已有检出可执行：

```bash
git submodule update --init --recursive
```

## 仓库结构

```text
.
├── assets/             # 壁纸和用户头像等静态资源
├── components/         # Git 子模块组件
│   ├── nixpi/          # Pi coding agent 的 Nix wrapper
│   └── nvim/           # Neovim 配置 Flake
├── hosts/              # 主机专属配置、硬件事实和服务
│   ├── amur/           # 桌面主机；含 ComfyUI 服务
│   ├── bengal/         # 桌面主机
│   ├── malayan/        # 远程 DERP 主机
│   ├── nixos-in-docker/# 独立 Home Manager 配置
│   └── sumatran/       # 家用服务器、网关和媒体服务
├── modules/
│   ├── nixos/
│   │   ├── core/       # 所有 NixOS 主机共享的基础能力
│   │   ├── server/     # server profile 及可选通用服务
│   │   ├── desktop/    # desktop profile 和桌面系统集成
│   │   └── home-manager.nix
│   ├── home-manager/
│   │   ├── server/     # CLI、shell、Helix、Git、Zellij 和 LLM agents
│   │   └── desktop/    # GUI 默认软件、额外软件和 CS2 配置
│   └── user/           # 可复用的系统与 Home Manager 用户 profile
├── secrets/            # agenix 声明和加密的 .age 文件
├── flake.nix           # Flake inputs、开发环境和输出
├── flake.lock          # Flake 输入锁文件
├── justfile            # 常用操作命令
└── lib.nix             # mkHost 实现
```

`components/nixpi` 和 `components/nvim` 分别通过 `path:./components/nixpi`、`path:./components/nvim` 作为 Flake input 引用。`nvim` 的默认包会传给 Home Manager，并安装到 server 用户环境中。

## Flake 输出

| 输出 | 配置入口 | Home Manager 用户 | 角色 |
| --- | --- | --- | --- |
| `nixosConfigurations.amur` | `hosts/amur/` | `asen` | 桌面主机，启用 NVIDIA、游戏、FHS、Docker、libvirtd、Bili-Sync、ComfyUI 和 Leigod plugin。 |
| `nixosConfigurations.bengal` | `hosts/bengal/` | `asen` | 桌面主机，启用 agenix、FHS、Mihomo、CLIProxyAPI、Docker 和 AArch64 用户态模拟。 |
| `nixosConfigurations.sumatran` | `hosts/sumatran/` | 无 | 家用服务器，提供 LAN 网络、dnsmasq、Docker、Mihomo、Bili-Sync 和 Jellyfin、Komga、Navidrome、OpenList 挂载等媒体服务。 |
| `nixosConfigurations.malayan` | `hosts/malayan/` | 无 | 轻量远程主机，运行自托管 DERP 服务。 |
| `homeConfigurations.root` | `hosts/nixos-in-docker/root.nix` | `root` | 供非 NixOS 环境使用的独立 Home Manager 配置。 |

`mkHost` 默认启用 Home Manager；`sumatran` 和 `malayan` 显式关闭。所有 NixOS 主机均导入 core profile；core 默认启用 Tailscale。server profile 在 core 之上提供系统用户、Pi overlay 和通用服务模块；desktop profile 则在 server 之上加入图形、音频、蓝牙、输入法、Flatpak、Wayland、主题和桌面 shell 集成。

## 配置约定

- 主机入口为 `hosts/<host>/default.nix`，主机硬件事实保留在 `hosts/<host>/hardware/`。
- 仅单台机器使用的网络和服务配置保留在对应的 `hosts/<host>/` 下；例如 `sumatran` 的网络和媒体服务、`amur` 的 ComfyUI。
- 系统用户 profile 位于 `modules/user/<name>/nixos.nix`，由 `custom.users.enabled` 选择。
- Home Manager 用户 profile 位于 `modules/user/<name>/home.nix`。有桌面角色的用户使用 `modules/home-manager/desktop/`，其他用户使用 `modules/home-manager/server/`。
- `custom.home.users.<name>` 用于主机级 Home Manager 覆盖：额外包、额外桌面应用和 Hyprland 显示器规则。
- `custom.*` 是仓库的意图层。主要命名空间包括 `custom.boot`、`custom.core.{kernel,power,tailscale}`、`custom.server.{agenix,bili-sync,cpa,fhs,mihomo,virtualization}`、`custom.desktop.{avatar,gaming,nvidia,theme}` 和 `custom.desktop.users`。Home Manager 还提供 `custom.desktop.{cs2,extra,hyprland}`。

## 开发与验证

进入开发环境：

```bash
nix develop
```

开发 shell 提供 `git`、`just`、`nixfmt`、`statix` 和 `deadnix`，并启用对应的 pre-commit hook。

构建或评估配置时，按变更范围选择最小充分验证：

```bash
nix flake check --no-build
nixos-rebuild dry-build --flake .#amur
nixos-rebuild dry-build --flake .#bengal
nixos-rebuild dry-build --flake .#sumatran
nixos-rebuild dry-build --flake .#malayan
home-manager build --flake .#root
```

## 常用命令

| 命令 | 说明 |
| --- | --- |
| `just deploy-local` | 使用 `nh os switch .` 部署当前本机配置。 |
| `just deploy-docker` | 应用独立的 `homeConfigurations.root`。 |
| `just deploy-remote-malayan` | 远程部署 `malayan`。 |
| `just deploy-remote-sumatran` | 远程部署 `sumatran`。 |
| `just debug` | 以详细输出执行本机 NixOS 切换。 |
| `just up [input]` | 更新全部或指定 Flake input。 |
| `just history` | 查看 NixOS generations。 |
| `just repl` | 启动 Nixpkgs REPL。 |
| `just clean` | 通过 `nh` 清理旧 generations。 |
| `just gc` | 清理未使用的 Nix store 内容。 |
| `just secret-edit <name>` | 编辑指定的 agenix 密钥。 |
| `just secret-rekey` | 重新加密 agenix 密钥。 |

部署、清理、密钥编辑和重加密会修改系统或密钥状态，执行前请确认目标主机和影响范围。

## 密钥管理

敏感信息由 agenix 管理：

- `secrets/secrets.nix` 声明受管理的密钥及其可解密主机。
- `secrets/*.age` 保存加密后的密钥内容。
- 需要密钥的模块通过 `config.age.secrets.<name>.path` 使用运行时解密文件。

不要在 Nix 文件、脚本、文档或提交信息中写入明文密码、私钥、订阅地址或 API token。
