# NixOS 配置项目 AI 协作指南

本文件是维护本仓库时的协作约定。修改配置前先阅读相关入口和已有模块，优先延续当前结构，不要根据旧路径或通用模板臆测实现。

## 1. 项目定位

这是一个使用 NixOS、Flake、Home Manager 和 agenix 管理的声明式系统配置仓库。核心目标是保持配置可重现、可迁移、模块化，并避免把主机特有逻辑散落到公共模块中。

当前稳定 Nixpkgs 分支为 `nixos-25.11`，同时通过 `nixpkgs-unstable` 提供少量需要较新版本的软件包。

## 2. 仓库结构

### 2.1 根目录

```text
.
├── flake.nix          # Flake 入口：inputs、NixOS 主机和独立 Home Manager 配置
├── flake.lock         # Flake 输入锁文件
├── lib.nix            # mkHost：统一组装 NixOS 主机、disko 和 Home Manager
├── justfile           # 常用部署、更新、清理和密钥管理命令
├── devenv.nix         # 开发环境与 nixfmt-rfc-style git hook
├── devenv.yaml
├── devenv.lock
├── hosts/             # 主机级配置
├── modules/           # 可复用 NixOS 和 Home Manager 模块
└── secrets/           # agenix 密钥声明与加密后的 .age 文件
```

### 2.2 Flake 输出与主机

`flake.nix` 通过 `lib.nix` 中的 `mkHost` 创建 NixOS 配置。`mkHost` 默认导入目标主机目录、`disko` 模块和 Home Manager 集成；可通过 `enableHomeManager = false` 关闭 Home Manager。

| Flake 输出 | 主机目录 | Home Manager 用户 | 用途 |
| --- | --- | --- | --- |
| `brain-holder` | `hosts/brain-holder/` | `asen` | 日常桌面主机 |
| `home-server` | `hosts/home-server/` | `wanglei` | 家用服务器 |
| `blue-10700` | `hosts/blue-10700/` | `asen` | 额外 NixOS 主机 |
| `rainyun` | `hosts/rain-cloud/` | 无 | 远程云主机 |
| `homeConfigurations.root` | `hosts/nixos-in-docker/root.nix` | `root` | 非 NixOS 环境中的独立 Home Manager 配置 |

注意：

- `rainyun` 的 Flake 输出名与目录名 `rain-cloud` 不同。
- 某些机器的 `networking.hostName` 使用了不同大小写，例如 `Blue-10700` 和 `RainYun`。修改时区分 Flake 输出名、目录名和系统 hostname。
- NixOS 主机入口统一使用 `hosts/<dir>/default.nix`。

### 2.3 主机目录

常规 NixOS 主机按以下方式组织：

```text
hosts/<host>/
├── default.nix                  # 主机入口，导入硬件、网络、用户和所需服务
├── hardware/
│   ├── default.nix
│   ├── filesystem.nix           # 主机专属磁盘布局、挂载点和 UUID
│   └── hardware-configuration.nix
├── network.nix                  # 或 network/ 目录
├── user.nix                     # 系统用户配置
└── users/<username>.nix         # Home Manager 用户入口
```

`home-server` 的网络配置拆分在 `hosts/home-server/network/` 下，由 `default.nix` 聚合。

`rain-cloud` 是轻量远程主机，在公共 core 的基础上直接导入目录内的 `tailscale.nix`、`derper.nix` 和 `my-derper.nix`。

### 2.4 可复用模块

系统级模块位于 `modules/nixos/`：

```text
modules/nixos/
├── core/                        # 所有 NixOS 主机共享的基础模块
│   ├── default.nix
│   ├── boot.nix                 # 通用默认值与 custom.hardware.boot 选项
│   ├── fonts.nix                # 桌面和服务器共用的基础字体
│   ├── i18n.nix
│   ├── nix.nix
│   ├── packages.nix
│   ├── ssh.nix
│   └── system.nix
├── hardware/                    # 通过 custom.hardware.* 开启的可复用硬件能力
│   ├── default.nix
│   ├── bluetooth.nix
│   ├── firmware.nix
│   ├── cpu/
│   │   └── intel.nix
│   ├── gpu/
│   │   └── nvidia.nix
│   ├── kernel/
│   │   └── cachyos.nix
│   └── storage/
│       └── ssd.nix
├── fhs.nix
├── home-manager.nix             # 按 hostName 和 usernames 加载用户配置
└── service/
    ├── default.nix              # 完整服务集合，brain-holder 使用
    ├── agenix.nix
    ├── gaming.nix
    ├── jellyfin.nix
    ├── mihomo.nix
    ├── nextcloud.nix
    ├── tailscale.nix
    ├── virtualization.nix
    └── desktop/
```

用户级模块位于 `modules/home-manager/`：

```text
modules/home-manager/
├── common/                      # 基础 CLI、shell、Helix、Git、Zellij 等
├── gui/                         # GNOME、Hyprland、Waybar、SwayNC、输入法等
├── extraServices/               # openlist、rclone
├── scripts/                     # scripts.nix 与脚本文件
├── ghostty.nix
├── llm-agents-package.nix
└── xdg-mimes.nix
```

### 2.5 敏感信息

仓库已经集成 agenix：

- `secrets/secrets.nix` 声明可解密密钥和加密文件。
- `secrets/*.age` 保存加密内容。
- `modules/nixos/service/agenix.nix` 提供 `myModule.agenix.enable`。
- 需要密钥的模块通过 `config.age.secrets.<name>.path` 读取运行时解密文件。

禁止在 `.nix`、脚本、文档或提交信息中新增明文密码、订阅地址、私钥和 API Token。发现历史遗留明文时，应指出风险并优先迁移到 agenix，不要继续复制扩散。

## 3. 架构约定

### 3.1 修改位置

- 所有主机共享的系统配置放入 `modules/nixos/core/`。
- 可复用但需要主机显式选择的硬件能力放入 `modules/nixos/hardware/`，并通过 `custom.hardware.*` 选项开启。
- 可选系统服务放入 `modules/nixos/service/`，优先定义 `options` 并使用 `lib.mkIf` 按需启用。
- 桌面系统服务放入 `modules/nixos/desktop/`。
- 所有用户共享的 Home Manager 配置放入 `modules/home-manager/common/`。
- 桌面用户配置放入 `modules/home-manager/gui/`。
- 仅单台机器使用的配置放入对应 `hosts/<host>/`。
- 可复用的 CPU、GPU、内核和存储优化放入 `modules/nixos/hardware/`。
- 主机专属磁盘布局、UUID 和 initrd 驱动保留在对应主机的 `hardware/`。

### 3.2 导入方式

- 公共 NixOS 基础模块通过 `../../modules/nixos/core` 导入。
- 主机硬件能力集中在 `hosts/<host>/hardware/default.nix` 中通过 `custom.hardware.*` 声明。
- 启动模式通过 `custom.hardware.boot.mode` 声明为 `"uefi"` 或 `"bios"`。
- `brain-holder` 导入完整的 `../../modules/nixos/service`。
- 其他主机按需导入具体服务文件，避免无意启用桌面、Jellyfin 或 Nextcloud 等服务。
- Home Manager 用户入口位于 `hosts/<host>/users/<username>.nix`，由 `modules/nixos/home-manager.nix` 自动加载。
- 外部 Flake 输入通过 `inputs` 参数使用；稳定软件包通过 `pkgs` 使用，需要新版本时再使用 `pkgsUnstable`。
- 不要直接引用 `<nixpkgs>` 全局路径。

### 3.3 命名

- 新文件和自定义属性优先使用小写字母与短横线组成的 kebab-case。
- 自定义模块选项沿用现有命名空间，例如 `modules.virtualization.custom.*`、`modules.network.clash.enable`、`modules.desktop.gaming.enable` 和 `myModule.agenix.enable`。
- 新增自定义选项时，优先使用清晰、统一的命名空间；不要为了一致性顺手重命名已有公开选项。

## 4. 常用工作流

### 4.1 开发环境

开发工具由 devenv 提供：

```bash
devenv shell
```

`devenv.nix` 启用了 `nixfmt-rfc-style` 和对应 git hook。格式化 Nix 文件时使用：

```bash
nixfmt <files...>
```

### 4.2 添加软件包

1. 判断软件包是系统级、公共用户级还是单主机专用。
2. 系统级软件包优先加入 `modules/nixos/core/packages.nix` 或对应服务模块。
3. 公共用户级软件包优先加入 `modules/home-manager/common/` 下合适模块。
4. 图形软件优先加入 `modules/home-manager/gui/` 下合适模块。
5. 仅单个用户或主机需要时，修改对应 `hosts/<host>/users/<username>.nix` 或主机模块。
6. 使用 `nix search nixpkgs <package>` 确认包名。

### 4.3 添加或修改系统服务

1. 检查 `modules/nixos/service/` 是否已有对应模块。
2. 通用可选服务优先新增独立模块，并使用 `options`、`lib.mkEnableOption` 和 `lib.mkIf`。
3. 只在需要该服务的主机入口导入并启用。
4. 检查端口、防火墙、运行用户、目录权限、密钥路径和服务依赖。
5. 对受影响主机执行 dry build。

### 4.4 新增主机

1. 创建 `hosts/<host>/default.nix`。
2. 按需添加 `hardware/`、网络模块、`user.nix` 和 `users/<username>.nix`。
3. 在 `flake.nix` 中通过 `myLib.mkHost` 注册输出。
4. 需要 Home Manager 时传入 `hostName` 和 `usernames`；否则设置 `enableHomeManager = false`。
5. 运行 `nixos-rebuild dry-build --flake .#<flake-output>`。

### 4.5 更新依赖

更新全部 Flake 输入：

```bash
just up
```

只更新一个输入：

```bash
just up <input>
```

更新后检查 `flake.lock` 变更，并至少 dry build 受影响主机。不要在未确认范围时顺手更新所有依赖。

### 4.6 管理 agenix 密钥

编辑指定密钥：

```bash
just secret-edit <name-without-age-suffix>
```

重新加密全部密钥：

```bash
just secret-rekey
```

新增密钥时同步更新 `secrets/secrets.nix`，只提交 `.age` 文件，不提交解密后的内容。

## 5. 部署命令

优先使用 `justfile` 中已有命令：

| 命令 | 目标 |
| --- | --- |
| `just deploy-brain` | 本机部署 `brain-holder` |
| `just deploy-server` | 本机部署 `home-server` |
| `just deploy-blue-10700` | 本机部署 `blue-10700` |
| `just deploy-remote` | 远程部署 `rainyun` |
| `just deploy-docker` | 应用独立 `root` Home Manager 配置 |
| `just up [input]` | 更新全部或指定 Flake 输入 |
| `just history` | 查看系统 profile 历史 |
| `just clean` | 清理旧系统 generations |
| `just gc` | 清理未使用的 Nix store 内容 |

部署、清理和密钥重加密会修改系统状态。除非用户明确要求，不要擅自执行。

## 6. 代码风格

- 修改 `.nix` 文件后运行 `nixfmt`。
- 保持列表项分行，相关配置放在同一逻辑块中。
- 局部变量使用可读名称，避免无意义缩写。
- 注释解释原因、约束或非直观行为，不重复描述代码表面含义。
- 新增模块时添加简短文件头注释，说明模块用途。
- TODO 和 FIXME 使用 `# TODO:`、`# FIXME:` 格式。
- 保持改动范围聚焦，不在功能变更中夹带无关重构。

## 7. 验证要求

根据变更范围执行最小充分验证：

### 7.1 文档修改

检查路径、命令和模块名是否与仓库一致：

```bash
git diff -- AGENTS.md
```

### 7.2 单个 Nix 文件修改

格式化并做语法检查：

```bash
nixfmt <file>
nix-instantiate --parse <file>
```

### 7.3 主机或公共模块修改

对每个受影响的 Flake 输出执行 dry build：

```bash
nixos-rebuild dry-build --flake .#brain-holder
nixos-rebuild dry-build --flake .#home-server
nixos-rebuild dry-build --flake .#blue-10700
nixos-rebuild dry-build --flake .#rainyun
```

只运行与改动相关的主机；公共基础模块改动应扩大验证范围。独立 Home Manager 配置使用：

```bash
home-manager build --flake .#root
```

## 8. Git 与协作

- 修改前检查 `git status --short`，不要覆盖用户尚未提交的改动。
- 提交信息使用英文 Conventional Commits，例如：

```text
feat: add home-server backup service
fix: correct home-manager import path
docs: refresh repository structure guide
chore: update flake lock
```

- 需求模糊、存在多种实现或涉及高风险系统状态变更时，先说明方案和影响，再请求确认。
- 与用户交流默认使用中文，除非用户明确要求其他语言。
