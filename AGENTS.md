# NixOS 配置项目 AI 协作指南

本文件是维护本仓库时的协作约定。修改配置前先阅读相关入口和已有模块，优先延续当前结构，不要根据旧路径或通用模板臆测实现。

## 1. 项目定位

这是一个使用 NixOS、Flake、Home Manager 和 agenix 管理的声明式系统配置仓库。核心目标是保持配置可重现、可迁移、模块化，并避免把主机特有逻辑散落到公共模块中。

当前 Nixpkgs 分支为 `nixos-unstable`。

## 2. 仓库结构

### 2.1 根目录

```text
.
├── flake.nix          # Flake 入口：开发环境、inputs、NixOS 主机和独立 Home Manager 配置
├── flake.lock         # Flake 输入锁文件
├── lib.nix            # mkHost：统一组装 NixOS 主机、disko 和 Home Manager
├── justfile           # 常用部署、更新、清理和密钥管理命令
├── hosts/             # 主机级配置
├── modules/           # 可复用 NixOS 和 Home Manager 模块
└── secrets/           # agenix 密钥声明与加密后的 .age 文件
```

### 2.2 Flake 输出与主机

`flake.nix` 通过 `lib.nix` 中的 `mkHost` 创建 NixOS 配置。`mkHost` 默认导入目标主机目录、`disko` 模块和 Home Manager 集成；可通过 `enableHomeManager = false` 关闭 Home Manager。

| Flake 输出 | 主机目录 | Home Manager 用户 | 用途 |
| --- | --- | --- | --- |
| `brain-holder` | `hosts/brain-holder/` | `asen` | 日常桌面主机 |
| `home-server` | `hosts/home-server/` | 无 | 家用服务器 |
| `bengal` | `hosts/bengal/` | `asen` | 额外 NixOS 主机 |
| `rainyun` | `hosts/rain-cloud/` | 无 | 远程云主机 |
| `homeConfigurations.root` | `hosts/nixos-in-docker/root.nix` | `root` | 非 NixOS 环境中的独立 Home Manager 配置 |

注意：

- `rainyun` 的 Flake 输出名与目录名 `rain-cloud` 不同。
- `rainyun` 的系统 hostname 为 `RainYun`。修改时区分 Flake 输出名、目录名和系统 hostname。
- NixOS 主机入口统一使用 `hosts/<dir>/default.nix`。

### 2.3 主机目录

常规 NixOS 主机按以下方式组织：

```text
hosts/<host>/
├── default.nix                  # 主机入口，导入硬件、网络并声明用户和所需服务
├── hardware/
│   ├── default.nix
│   ├── filesystem.nix           # 主机专属磁盘布局、挂载点和 UUID
│   └── hardware-configuration.nix
└── network.nix                  # 或 network/ 目录
```

`home-server` 的网络配置拆分在 `hosts/home-server/network/` 下，由 `default.nix` 聚合。

`rain-cloud` 是轻量远程主机，在公共 core 的基础上直接导入目录内的 `tailscale.nix`、`derper.nix` 和 `my-derper.nix`。

### 2.4 可复用模块

系统级模块位于 `modules/nixos/`：

```text
modules/nixos/
├── core/                        # 所有 NixOS 主机共享的基础模块
│   ├── default.nix
│   ├── boot.nix                 # 通用默认值与 custom.boot 选项
│   ├── fonts.nix                # 桌面和服务器共用的基础字体
│   ├── i18n.nix
│   ├── nix.nix
│   ├── packages.nix
│   ├── security.nix
│   ├── ssh.nix
│   ├── system.nix
│   ├── power.nix
│   ├── kernel.nix
│   └── tailscale.nix
├── server/                      # 服务器 NixOS profile 入口，包含系统用户和通用服务
│   ├── agenix.nix
│   ├── cli-proxy-api.nix
│   ├── fhs.nix
│   ├── mihomo.nix
│   └── virtualization.nix
├── desktop/                     # 桌面 NixOS profile 入口，通过 custom.desktop.* 开启桌面能力
│   ├── amd.nix
│   ├── avatar.nix
│   ├── gaming.nix
│   ├── nvidia.nix
│   ├── terminal.nix
│   ├── theme.nix
│   ├── core/                    # 图形、音频、蓝牙、输入法、字体、基础工具和 Wayland portal
│   ├── shell/                   # DMS shell、Hyprland session 和 greeter
└── home-manager.nix             # 加载用户 Home Manager role 并应用主机级 custom.home.users.* 默认值
```

用户级模块位于 `modules/home-manager/`：

```text
modules/home-manager/
├── server/                      # server 用户环境，基础 CLI、shell、Helix、Git、Zellij、LLM agents 等
├── desktop/                     # desktop 用户环境，继承 server
│   ├── dms/                     # DMS 和 Hyprland 会话配置
│   ├── browser.nix              # 默认应用、用户应用配置和 XDG MIME 关联等平铺模块
│   └── ...
```

可复用用户定义位于 `modules/user/`，按用户同时保存系统侧和 Home Manager 侧配置：

```text
modules/user/
└── asen/
    ├── nixos.nix
    └── home.nix
```

### 2.5 敏感信息

仓库已经集成 agenix：

- `secrets/secrets.nix` 声明可解密密钥和加密文件。
- `secrets/*.age` 保存加密内容。
- `modules/nixos/server/agenix.nix` 提供 `custom.server.agenix.enable`。
- 需要密钥的模块通过 `config.age.secrets.<name>.path` 读取运行时解密文件。

禁止在 `.nix`、脚本、文档或提交信息中新增明文密码、订阅地址、私钥和 API Token。发现历史遗留明文时，应指出风险并优先迁移到 agenix，不要继续复制扩散。

### 2.6 外部参考仓库

需要参考更完整的 NixOS/Home Manager 桌面设计、模块拆分、密钥分层或多主机组织方式时，可以查看以下公开仓库。它们仅作为设计参考，不直接覆盖本仓库结构和命名约定；参考前先确认对应文件在上游当前版本中的实际路径和实现，不要凭记忆照搬。

| 仓库 | 适合参考的方向 |
| --- | --- |
| `https://github.com/Misterio77/nix-starter-configs` | 新配置模板；NixOS + Home Manager + flakes 的清晰脚手架。 |
| `https://github.com/hlissner/dotfiles` | 大型个人 NixOS 配置组织方式；复杂度高，只看结构和边界，不直接抄实现。 |
| `https://github.com/fufexan/dotfiles` | flake-parts、Home Manager、NixOS modules、`home/`、`hosts/`、`modules/`、`secrets/` 等模块拆分。 |
| `https://github.com/mitchellh/nixos-config` | 少抽象、偏直接的真实 NixOS 配置实践。 |
| `https://github.com/raexera/yuki` | NixOS + Home Manager + flakes + flake-parts，偏 Hyprland 桌面美化。 |
| `https://github.com/malob/nix-config` | NixOS、nix-darwin、Home Manager 的多平台统一管理。 |
| `https://github.com/JaKooLit/NixOS-Hyprland` | NixOS + Hyprland 自动安装和整合思路；注意其 dot configs 不一定是纯 Nix 声明式配置。 |
| `https://github.com/BirdeeHub/nix-wrapper-modules` | 用 Nix module 包装带配置的软件；适合参考桌面组件和应用配置抽象方式。 |
| `https://github.com/NobbZ/nixos-config` | 老牌 Nix 配置仓库，可参考 flake 和配置组织。 |
| `https://github.com/oddlama/nix-config` | 实际维护中的个人 Nix config + dotfiles。 |
| `https://github.com/pinpox/nixos` | 多机、服务端、secrets 和 configuration management 方向。 |
| `https://github.com/yunfachi/denix` | 可扩展 Nix 配置框架，面向 NixOS/Home Manager/nix-darwin 的 hosts、rices、modules 组织。 |
| `https://github.com/ryan4yin/nix-config` | 桌面设计、密钥分层、GUI 应用密码管理和浏览器密码集成。 |

对网站和 GUI 应用账户密码，优先参考 `ryan4yin/nix-config` 中 `pass`/GPG password-store 与 `browserpass` 的设计：Nix 固化工具链和 native messaging，密码数据留在加密 password-store 中，不把 Firefox 的 `logins.json`、`key4.db` 或明文账户密码写入本仓库。对系统服务密钥，参考其 agenix 分层思路；在本仓库中仍优先沿用现有 `secrets/secrets.nix` 和 `modules/nixos/server/agenix.nix`。

## 3. 架构约定

### 3.1 修改位置

- 所有主机共享的无用户最小系统配置放入 `modules/nixos/core/`。
- 需要主机显式选择的系统能力按适用范围放入 `modules/nixos/core/`、`server/` 或 `desktop/`，并分别通过 `custom.core.*`、`custom.server.*` 或 `custom.desktop.*` 选项开启；desktop 的 `core/` 只放无自定义选项的桌面基础能力。
- 可选通用系统服务放入 `modules/nixos/server/`，优先定义 `options` 并使用 `lib.mkIf` 按需启用。
- 桌面系统服务放入 `modules/nixos/desktop/`。
- NixOS 主机角色聚合入口直接放入 `modules/nixos/core/`、`modules/nixos/server/` 和 `modules/nixos/desktop/`。
- CLI 和显示无关的 Home Manager 用户环境放入 `modules/home-manager/server/`。
- 桌面系统 profile 放入 `modules/nixos/desktop/`；桌面用户默认值放入 `modules/home-manager/desktop/`。
- Home Manager 用户环境聚合入口直接放入 `modules/home-manager/server/` 和 `modules/home-manager/desktop/`；没有 `core` 用户环境，因为 NixOS `core` 是无个人用户的最小主机层。
- 仅单台机器使用的配置放入对应 `hosts/<host>/`。
- 内核和电源策略放入 `modules/nixos/core/`；系统用户、通用服务入口和虚拟化放入 `modules/nixos/server/`；桌面基础图形、音频、蓝牙、输入法和工具放入 `modules/nixos/desktop/core/`，NVIDIA、AMD、gaming、shell、theme、terminal 和 avatar 等可选能力放入 `modules/nixos/desktop/`。
- 主机专属磁盘布局、UUID、initrd 驱动、固件开关和 `nixos-hardware` 导入保留在对应主机的 `hardware/`。

### 3.2 导入方式

- 主机入口通过 `../../modules/nixos/core`、`server` 或 `desktop` 导入公共 NixOS 配置；不要在主机里手动拼同一组公共模块。
- 主机硬件事实集中在 `hosts/<host>/hardware/default.nix` 中，包括 `nixos-hardware` 的机型或通用硬件模块；可复用系统能力在主机入口中通过 `custom.core.*`、`custom.server.*` 和 `custom.desktop.*` 声明。
- 启动模式通过 `custom.boot.mode` 声明为 `"uefi"` 或 `"bios"`。
- `core` profile 不创建个人用户，默认启用 Tailscale；`server` profile 在 core 上增加系统用户和通用服务选项；`desktop` profile 在 server 上默认启用图形、音频和蓝牙能力。
- 其他主机按需导入具体服务文件，避免无意启用桌面或 Jellyfin 等服务。
- 用户定义位于 `modules/user/<username>/`，其中 `nixos.nix` 是系统账号 profile，`home.nix` 是 Home Manager 用户身份 profile；由 `modules/nixos/server/default.nix` 和 `modules/nixos/home-manager.nix` 自动加载。用户环境默认采用 `desktop` 或 `server` HM role，也可在主机入口通过 `custom.home.users.<username>.role` 覆盖。主机专属用户默认值放在主机入口的 `custom.home.users.<username>`。
- 外部 Flake 输入通过 `inputs` 参数使用；Nixpkgs 软件包统一通过 `pkgs` 使用。
- 不要直接引用 `<nixpkgs>` 全局路径。

### 3.3 自定义选项设计

- `custom.*` 选项是本仓库的 profile 和意图层，用来把主机配置简化为“启用什么能力、采用什么角色或模式”，不要把它设计成 NixOS、Home Manager 原生选项的一比一镜像。
- 新增 `custom.*` 选项前先判断它是否能隐藏一组重复的底层配置、表达仓库内稳定的 profile，或隔离主机间的差异；如果只是改名转发单个原生选项，优先直接使用原生选项。
- 模块内部负责把 `custom.*` profile 展开为具体的 `hardware.*`、`services.*`、`programs.*`、`virtualisation.*` 等原生配置；主机文件只保留 profile 选择和无法抽象的机器事实，例如 PCI Bus ID、UUID、hostname、用户名和端口。
- 可复用模块应提供保守默认值，避免启用只有特定硬件、特定角色或特定部署场景才需要的能力；这类能力应通过明确的 role、mode 或子 profile 开启。
- 系统用户账号定义放在 `modules/user/<username>/nixos.nix`，server 和 desktop 主机通过 `custom.users.enabled` 声明启用哪些用户；主机专属 groups 或 SSH authorized keys 通过对应用户子选项追加，不再为每台主机维护重复的 `user.nix`。
- Home Manager 用户身份差异放在 `modules/user/<username>/home.nix`；用户环境 role 放在 `modules/home-manager/server/` 和 `modules/home-manager/desktop/`；主机只通过 `custom.home.users.<username>` 声明 role 覆盖、额外用户包、Hyprland 输出规则、Firefox 代理等主机差异，不再为每台主机维护重复的 `users/<username>.nix`。

### 3.4 命名

- 新文件和自定义属性优先使用小写字母与短横线组成的 kebab-case。
- 自定义模块选项沿用现有命名空间，例如 `modules.virtualization.custom.*`、`modules.network.clash.enable`、`custom.desktop.gaming.enable`、`custom.home.users.<name>.*` 和 `myModule.agenix.enable`。
- 新增自定义选项时，优先使用清晰、统一的命名空间；不要为了一致性顺手重命名已有公开选项。

## 4. 常用工作流

### 4.1 开发环境

开发工具由 Flake 默认 dev shell 提供：

```bash
nix develop
```

`flake.nix` 的默认 dev shell 提供 `git`、`just`、`nixfmt`，并启用对应的 pre-commit hook。无需每次修改后手动格式化；提交时 pre-commit 会自动处理。需要提前整理格式时使用：

```bash
nixfmt <files...>
```

### 4.2 添加软件包

1. 判断软件包是系统级、公共用户级还是单主机专用。
2. 系统级软件包优先加入 `modules/nixos/core/packages.nix` 或对应服务模块。
3. 公共用户级软件包优先加入 `modules/home-manager/server/` 下合适模块。
4. 图形软件优先加入 `modules/nixos/desktop/` 下合适 profile。
5. 仅单个用户或主机需要时，优先放入对应主机入口的 `custom.home.users.<username>.extraPackages`；多个主机共享时再放入 `modules/user/<username>/home.nix` 或 `modules/home-manager/server/`。
6. 使用 `nix search nixpkgs <package>` 确认包名。

### 4.3 添加或修改系统服务

1. 检查 `modules/nixos/server/` 是否已有对应模块。
2. 通用可选服务优先新增独立模块，并使用 `options`、`lib.mkEnableOption` 和 `lib.mkIf`。
3. 只在需要该服务的主机入口导入并启用。
4. 检查端口、防火墙、运行用户、目录权限、密钥路径和服务依赖。
5. 对受影响主机执行 dry build。

### 4.4 新增主机

1. 创建 `hosts/<host>/default.nix`。
2. 按需添加 `hardware/` 和网络模块。
3. 在主机入口导入合适的 `modules/nixos/core`、`server` 或 `desktop` profile，通过 `custom.users.enabled` 声明系统用户，并按需配置 `custom.home.users.<username>`。
4. 在 `flake.nix` 中通过 `myLib.mkHost` 注册输出。
5. 需要 Home Manager 时传入 `usernames`；否则设置 `enableHomeManager = false`。
6. 运行 `nixos-rebuild dry-build --flake .#<flake-output>`。

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
| `just deploy-local` | 根据当前 hostname 部署对应的本地 NixOS 主机 |
| `just deploy-remote` | 远程部署 `rainyun` |
| `just deploy-docker` | 应用独立 `root` Home Manager 配置 |
| `just up [input]` | 更新全部或指定 Flake 输入 |
| `just history` | 查看系统 profile 历史 |
| `just clean` | 清理旧系统 generations |
| `just gc` | 清理未使用的 Nix store 内容 |

部署、清理和密钥重加密会修改系统状态。除非用户明确要求，不要擅自执行。

## 6. 代码风格

- 不需要每次修改 `.nix` 文件后立即运行 `nixfmt`；提交时由 git pre-commit hook 自动格式化。仅在需要提前查看格式化结果或排查格式问题时手动运行。
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

按需格式化，并做语法检查：

```bash
nixfmt <file>
nix-instantiate --parse <file>
```

### 7.3 主机或公共模块修改

对每个受影响的 Flake 输出执行 dry build：

```bash
nixos-rebuild dry-build --flake .#brain-holder
nixos-rebuild dry-build --flake .#home-server
nixos-rebuild dry-build --flake .#bengal
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
