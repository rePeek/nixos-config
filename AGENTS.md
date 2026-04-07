# NixOS 配置项目 AI 协作指南
欢迎！本文件旨在指导 AI（以及人类协作者）如何高效、一致地维护和扩展此 NixOS 配置仓库。请将此文件视为项目的“宪法”，所有修改和新增都应遵循其中的原则与规则。

## 1. 项目概述
### 1.1 概述
这是一个使用 NixOS 和 Flake 管理的系统配置文件仓库。目标是通过声明式配置实现可重现、可迁移的系统环境。

核心原则：声明式、不可变性、可重现、模块化。

仓库结构（根目录）：

* `flake.nix`：主入口，定义 inputs、outputs、`nixosConfigurations` 与 `homeConfigurations`。
* `flake.lock`：锁定所有依赖版本。
* `justfile`：常用构建、部署、更新、清理命令（基于 `just` 命令运行器）。
* `devenv.nix` / `devenv.yaml` / `devenv.lock`：开发环境定义。
* `BEADS.md`：任务追踪规范（`bd` 工作流）。
* `AGENTS.md`：AI 协作规范（本文件）。
* `hosts/`：各主机配置。
  * `brain-holder/`：日常主力机配置。
    * `default.nix`：主机入口模块。
    * `network.nix`、`user.nix`、`misc.nix`、`clash-verge.nix`：主机功能模块。
    * `hardware/`：硬件相关配置（`default.nix`、`disk.nix`、`filesystem.nix`、`gpu.nix`、`hardware-configuration.nix`）。
    * `users/asen.nix`：用户配置。
  * `home-server/`：家用服务器配置。
    * `configuration.nix`：主机入口模块。
    * `network.nix`、`user.nix`：主机功能模块。
    * `hardware/`：硬件相关配置（`default.nix`、`disk.nix`、`filesystem.nix`、`hardware-configuration.nix`）。
    * `users/wanglei.nix`：用户配置。
  * `nixos-in-docker/`：非 NixOS 场景的 home-manager 配置。
    * `root.nix`：root 用户 home-manager 配置。
* `modules/`：可复用模块。
  * `nixos/`：系统级模块。
    * 顶层模块：`default.nix`、`boot.nix`、`i18n.nix`、`misc.nix`、`nix.nix`、`pkgs.nix`、`ssh.nix`、`home-manager.nix`。
    * `extraServices/`：额外服务模块（如 `dae.nix`、`gaming.nix`、`jellyfin.nix`、`nextcloud.nix`、`tailscale.nix`、`virtualization.nix`）。
    * `extraServices/desktop/`：桌面相关系统模块（如 `wayland.nix`、`pipewire.nix`、`fonts.nix`、`bluetooth.nix`、`greeted.nix`、`security.nix`、`power.nix`、`misc.nix`）。
  * `home-manager/`：用户级模块。
    * `common/`：基础模块（`home.nix`、`git.nix`、`btop.nix`、`zellij.nix`、`helix/`、`shell/`）。
    * `gui/`：图形环境模块（`hyprland/`、`waybar/`、`swaync/`、`rofi.nix`、`swaylock.nix`、`gtk.nix` 等）。
    * `extraServices/`：用户级额外服务（`openlist.nix`、`rclone.nix`）。
    * `scripts/`：脚本集合与入口（`scripts.nix` + `scripts/*.sh`）。
    * 其他模块：`ghostty.nix`、`llm-agents-package.nix`、`xdg-mimes.nix`。
* `overlays/`：Nixpkgs overlays（预留目录）。
* `secrets/`：加密秘密文件目录（预留）。
* `wallpapers/`：壁纸资源。

### 1.2 项目开发

使用 `bd` 作为任务追踪，请先阅读 `BEADS.md` 并严格遵循。

## 2. 技术栈与核心约束
### 2.1 技术栈
语言：Nix（配置文件以 `.nix` 结尾）

包管理器：Nixpkgs（通过 flake 输入引入，当前主分支为 `nixos-25.11`）

配置入口：`flake.nix` 是唯一入口，输出 `nixosConfigurations` 和 `homeConfigurations`。

构建/部署工具：优先使用 `justfile` 中定义命令（如 `just deploy-brain`、`just deploy-server`、`just deploy-docker`、`just up`、`just fmt`）。若无对应命令，可回退到原生命令。

敏感信息：所有密码、密钥、API Token 必须通过加密方式管理（如 agenix 或 sops-nix）。严禁明文写入任何 `.nix` 文件。

### 2.2 架构规则
模块化：

所有功能应按逻辑拆分为独立模块，优先放入 `modules/nixos/` 或 `modules/home-manager/` 下已有分层。

每个模块目录建议使用 `default.nix` 作为入口，可引用同目录子文件。

通用 home-manager 集成在 `modules/nixos/home-manager.nix`，由 `flake.nix` 按主机传入 `hostName` 与 `usernames`。

命名规范：

文件名、属性名均使用小写字母 + 短横线（kebab-case），例如 `ssh-server.nix`。

模块内选项命名遵循 Nixpkgs 惯例，如 `services.<name>.<option>`、`programs.<name>.<option>`。

选项定义：公共模块应优先定义明确选项（`options`）并通过 `config` 条件启用，避免硬编码。

依赖管理：所有外部包通过 `pkgs` 参数传入，不直接引用 `<nixpkgs>` 全局路径（特殊情况需注释说明）。

主机配置：

每个主机在 `hosts/` 下有独立目录，目录名需与 `flake.nix` 中主机名一致。

当前仓库同时存在 `default.nix`（如 `brain-holder`）与 `configuration.nix`（如 `home-server`）两种入口形式；新增主机时二选一并保持一致性。

## 3. 代码风格与格式
### 3.1 格式化
所有 `.nix` 文件必须格式化。优先使用 `just fmt`（当前封装为 `treefmt .`）。

### 3.2 注释规范
文件头注释：模块文件开头应有简要说明，例如：

```nix
# ssh.nix
# SSH 服务配置，限制 root 登录并启用密钥认证。
```

复杂逻辑注释：对非直观 Nix 表达式（如递归合并、高阶函数）添加注释解释意图。

TODO/FIXME：使用 `# TODO:` 或 `# FIXME:` 标记待办，并尽可能附 issue 链接或责任人。

### 3.3 命名与结构
变量绑定：`let ... in` 的局部变量使用有意义名字，避免 `x`、`y` 等缩写。

列表与属性集：列表项尽量换行，属性集尽量按字母序组织。

空行：不同逻辑块之间用空行分隔，提高可读性。

## 4. 常见任务工作流程
请 AI 在处理以下任务时，严格遵循对应步骤。

### 4.1 添加一个新软件包
定位：确定包属于系统级（所有用户可用）还是用户级（特定用户）。

修改位置：

系统级：优先在 `modules/nixos/pkgs.nix` 或对应服务模块添加；如仅某主机需要，可在该主机入口（如 `hosts/brain-holder/default.nix` 或 `hosts/home-server/configuration.nix`）添加。

用户级（home-manager）：在对应用户模块或 home-manager 公共模块添加（如 `hosts/*/users/*.nix`、`modules/home-manager/common/home.nix`）。

包名确认：使用 `nix search nixpkgs <包名>` 验证包名。

额外配置：若需启用服务或写配置，同步修改对应模块。

### 4.2 启用/修改一个系统服务
找到服务模块：若已有专用模块（如 `services.openssh`，或仓库内 `modules/nixos/extraServices/*.nix`），优先在该模块中修改；若无，新增模块并接入 `modules/nixos/default.nix`。

修改选项：调整服务选项值。

检查依赖：确保端口、防火墙、用户与目录权限配置齐全。

测试：优先执行 dry build（如 `nixos-rebuild dry-build --flake .#brain-holder`），再按需执行部署命令。

### 4.3 更新系统
更新 flake 锁文件：优先 `just up`（等价 `nix flake update`）。

选择性更新：若仅更新某个输入，使用 `just upp i=<input>` 或 `nix flake lock --update-input <input>`。

应用更新：按目标主机使用 `just deploy-brain` / `just deploy-server` / `just deploy-docker`。

回滚准备：重大更新前可运行 `nixos-rebuild boot --flake .#<host>` 先生成新启动项。

### 4.4 处理敏感信息（以 agenix 为例）
若仓库尚未集成敏感信息管理，请先与用户确认是否引入，再执行：

添加新密钥：使用 `agenix -e secrets/<name>.age` 编辑加密文件（先配置 `secrets.nix` 与密钥）。

在配置中引用：通过 `config.age.secrets.<name>.path` 使用解密后路径。

权限设置：确保解密后文件权限正确（如 SSH 私钥 `0600`）。

### 4.5 新增一台主机
创建主机目录：在 `hosts/` 下创建与主机名一致的目录。

创建系统配置：在目录内创建入口文件（`default.nix` 或 `configuration.nix`）并导入所需模块。

配置用户：在 `hosts/<host>/users/` 中添加用户模块，并在 `flake.nix` 的 home-manager 注入参数中声明用户名。

更新 `flake.nix`：在 `nixosConfigurations` 中添加新主机条目并接入所需模块（如 disko、home-manager）。

测试构建：运行 `nixos-rebuild dry-build --flake .#<host>` 确认可构建。

## 5. 沟通与协作模式
### 5.1 AI 提问规范
当需求模糊、多方案可选或存在风险时，AI 应：

列出方案：简述各方案优缺点。

请求确认：明确提问（例如“请确认使用方案 A 还是 B”）。

等待指令：在确认前不擅自执行高风险方案。

### 5.2 变更记录
对于较大功能添加或重构，请同步更新文档（如 `wiki/` 目录，若存在）。

若项目使用 Git，提交信息应遵循 Conventional Commits。

### 5.3 Git 提交规范
提交信息格式：

```text
<type>: <short description>

[optional body]

[optional footer]
```

类型（type）：

- `feat`：新增功能或模块
- `fix`：修复错误
- `docs`：仅文档更改
- `style`：代码风格或格式化（不影响功能）
- `refactor`：重构（非修复、非新增）
- `test`：测试相关变更
- `chore`：维护任务（工具、依赖、杂务）
- `build`：构建系统或依赖项更改
- `perf`：性能优化
- `revert`：回滚提交

示例：

```text
feat: add home-server jellyfin service
fix: fix home-manager module import path
docs: update AGENTS structure section
chore: update flake lock
```

注意事项：

- 提交信息使用英文
- 描述使用祈使句、现在时态（如 `add`，非 `added`）
- 正文说明原因和影响范围
- 页脚可关联 issue 或 Breaking Change

### 5.4 约束与限制
禁止引入不稳定特性：除非明确要求，否则避免引入实验性或不稳定配置。

保持精简：不随意添加不必要依赖，避免系统臃肿。

硬件相关配置：优先放在 `hosts/<host>/hardware/` 或明确的硬件模块中，避免散落硬编码。

`justfile` 优先：若有对应 `just` 命令，优先使用以保持一致性。

### 5.5 语言要求

所有与用户的交流、回复、提问、解释等，请使用中文，除非用户明确要求其他语言。

## 6. 测试与验证
在提交任何更改前，AI 应建议或执行以下验证：

语法检查：`nix-instantiate --parse <file>` 或 `nix eval --file <file>`。

构建测试：对受影响主机运行 `nixos-rebuild dry-build --flake .#<host>`。

模块兼容性：修改公共模块后，可用 `nix eval .#nixosConfigurations.<host>.config` 检查选项合并结果。

格式检查：运行 `just fmt` 保持风格一致。

## 7. 附则
本文件会随项目演进持续更新，AI 应定期查阅最新版本。

任何与本文件冲突的临时指令，请先与用户确认优先级。

如果不确定某条规则是否适用，请主动提问。
