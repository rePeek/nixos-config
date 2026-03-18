# NixOS 配置项目 AI 协作指南
欢迎！本文件旨在指导 AI（以及人类协作者）如何高效、一致地维护和扩展此 NixOS 配置仓库。请将此文件视为项目的“宪法”，所有修改和新增都应遵循其中的原则与规则。

## 1. 项目概述
### 1.1 概述
这是一个使用 NixOS 和 Flake 管理的系统配置文件仓库。目标是通过声明式配置实现可重现、可迁移的系统环境。

核心原则：声明式、不可变性、可重现、模块化。

仓库结构（根目录）：

* flake.nix：主入口，定义输入、输出和主机配置。

* flake.lock：锁定所有依赖版本。

* justfile：常用构建、部署、更新命令（基于 just 命令运行器）。

* LICENSE：许可证文件。

* hosts/：存放各主机的独立配置。
  * brain-holder/：物理机或主要工作机的配置目录。
    * default.nix：主配置文件（替代传统的 configuration.nix）。
    * bootloader.nix、disko-config.nix、network.nix、gpu.nix、hardware-configuration.nix、user.nix：各功能模块。
    * containers/：容器配置（如 nextcloud.nix）。
    * users/：用户配置文件（如 asen.nix）。
  * nixos-in-docker/：Docker 容器内的 NixOS 配置。
    * root.nix：root 用户的 home-manager 配置。

* modules/：可复用的 NixOS 和 home-manager 模块。
  * nixos/：系统级模块。
    * common/：通用模块。
      * default.nix、nix.nix、pipewire.nix、program.nix、security.nix、services.nix、system.nix、wayland.nix、xserver.nix：基础配置模块。
      * extraServices/：额外服务配置（如 container.nix、dae.nix、jellyfin.nix、nextcloud.nix 等）。
      * pkgs/：软件包配置（如 steam.nix）。
      * home-manager.nix：通用 home-manager 启用配置。
  * home-manager/：用户级模块。
    * common/：通用用户配置。
      * default.nix、home.nix、btop.nix、git.nix、zellij.nix：基础用户模块。
      * helix/：Helix 编辑器配置。
      * shell/：Shell 配置（aliases.nix、fish.nix、fzf.nix 等）。
    * gui/：图形界面配置。
      * hyprland/、waybar/、rofi.nix、swaylock.nix、swaync/ 等。
    * scripts/：用户脚本。
    * 其他模块：ghostty.nix、llm-agents-package.nix、openlist.nix、rclone.nix、xdg-mimes.nix 等。

* overlays/：Nixpkgs overlays（目前为空，预留目录）。

* secrets/：加密的秘密文件存储目录（使用 agenix 或 sops-nix）。

* wallpapers/：壁纸图像存储目录。

### 1.2 项目开发

使用 'bd' 作为任务追踪，请先阅读 BEADS.md 中的内容，并严格遵循。

## 2. 技术栈与核心约束
### 2.1 技术栈
语言：Nix（所有配置文件均以 .nix 结尾）

包管理器：Nixpkgs（通过 flake 输入引入，通常为 nixpkgs 和可能的 unstable）

配置入口：flake.nix 是唯一入口，输出 nixosConfigurations 和 homeConfigurations。

构建/部署工具：优先使用 justfile 中定义的命令（如 just rebuild、just update）。若无相应命令，可回退至原生命令（nixos-rebuild 等）。

敏感信息：所有密码、密钥、API Token 必须 通过加密方式管理（如 agenix 或 sops-nix）。目前项目中尚未引入，若添加需严格遵循。严禁明文写入任何 .nix 文件。

### 2.2 架构规则
模块化：

所有功能应按逻辑拆分为独立模块，放在 modules/nixos/ 下的相应子目录（如 services/、programs/、hardware/ 等）。

每个模块包含一个 default.nix 作为入口，可引用同目录下的子文件。

通用 home-manager 配置已存在于 modules/nixos/common/home-manager.nix，可在此处启用 home-manager 并导入用户级配置。

命名规范：

文件名、属性名均使用 小写字母 + 短横线（kebab-case），例如 ssh-server.nix。

模块内的选项命名遵循 Nixpkgs 惯例，如 services.<name>.<option> 或 programs.<name>.<option>。

选项定义：模块应定义明确的选项（options），并在 config 中根据选项启用功能。避免硬编码，提高复用性。

依赖管理：所有外部包必须通过 pkgs 参数传入，不得直接引用 <nixpkgs> 等全局路径（除非在极特殊情况并注释说明）。

主机配置：

每个主机在 hosts/ 下有自己的目录，目录名应与 flake.nix 中定义的主机名一致。

主机目录内应包含 default.nix（系统配置，替代传统的 configuration.nix）和可选的 home.nix（若使用 home-manager 单独管理用户）。目前 nixos-in-docker/root.nix 是一个特例，它为 root 用户提供了 home-manager 配置。

## 3. 代码风格与格式
### 3.1 格式化
所有 .nix 文件必须使用 nixpkgs-fmt 格式化。提交前请运行 nixpkgs-fmt .（若 justfile 中有 format 命令，优先使用）。

### 3.2 注释规范
文件头注释：每个模块文件开头应有简要说明，例如：

nix
# ssh-server.nix
# SSH 服务配置，支持密钥认证，禁止 root 登录。
复杂逻辑注释：对于非直观的 Nix 表达式（如递归合并、高阶函数）必须添加注释解释意图。

TODO/FIXME：使用 # TODO: 或 # FIXME: 标记待办事项，并尽可能附上 issue 链接或责任人。

### 3.3 命名与结构
变量绑定：let ... in 中的局部变量应使用有意义的名字，避免使用 x、y 等无意义缩写。

列表与属性集：列表项尽量换行，属性集按字母顺序排序（可手动或借助工具）。

空行：不同逻辑块之间用空行分隔，提高可读性。

## 4. 常见任务工作流程
请 AI 在处理以下任务时，严格遵循对应的步骤。

### 4.1 添加一个新软件包
定位：确定该软件包属于系统级（所有用户可用）还是用户级（仅特定用户）。

修改位置：

系统级：在对应主机的 configuration.nix 中的 environment.systemPackages 列表中添加，或在公共模块（如 modules/nixos/common/packages.nix）中添加（若尚未创建，建议创建此类模块）。

用户级（home-manager）：在对应用户的 home-manager 配置文件中添加，例如 hosts/nixos-in-docker/root.nix 中的 home.packages 列表。

包名确认：使用 nix search nixpkgs <包名> 验证包名是否准确。

额外配置：若需要启用服务或进行配置，一并修改对应服务模块。

### 4.2 启用/修改一个系统服务
找到服务模块：若该服务已有专用模块（如 services.openssh），直接在主机配置中启用并设置选项；若无，则在 modules/nixos/services/ 下新建模块（遵循模块化规则）。

修改选项：调整对应服务的选项值。

检查依赖：确保相关端口、用户、防火墙规则等已正确配置（如防火墙可能需要开放端口）。

测试：运行 just test（若已定义）或 sudo nixos-rebuild test --flake .#<主机名> 测试配置，确认服务启动正常且无报错。

### 4.3 更新系统
更新 flake 锁文件：运行 just update（若已定义）或 nix flake update 更新 flake.lock 中的所有依赖。

选择性更新：若只需更新 nixpkgs，可运行 nix flake lock --update-input nixpkgs。

应用更新：运行 just switch 或 sudo nixos-rebuild switch --flake .#<主机名> 应用新配置。

回滚准备：在重大更新前，建议先运行 sudo nixos-rebuild boot --flake .#<主机名> 生成新条目但不立即切换，以便重启后手动选择旧版本。

### 4.4 处理敏感信息（以 agenix 为例）
若项目中尚未集成敏感信息管理，请先与用户确认是否引入，并参考以下步骤：

添加新密钥：将明文秘密文件放入临时目录，使用 agenix -e secrets/<秘密名>.age 编辑加密文件（需先配置好 secrets.nix 和密钥）。

在配置中引用：在模块中通过 config.age.secrets.<秘密名>.path 获取解密后的路径。

权限设置：确保解密后的文件权限正确（如 SSH 私钥应为 0600）。

### 4.5 新增一台主机
创建主机目录：在 hosts/ 下新建目录，名称与主机名一致。

创建系统配置：在目录内创建 configuration.nix，导入所需模块，并设置主机专属选项。

配置 home-manager（可选）：若该主机需要用户级配置，可在目录内创建 home.nix，并在 flake.nix 中通过 homeConfigurations 输出。

更新 flake.nix：在 nixosConfigurations 中添加新主机条目，引用刚创建的 configuration.nix。

测试构建：运行 just build <新主机名> 或 nixos-rebuild dry-build --flake .#<新主机名> 确保配置无误。

## 5. 沟通与协作模式
### 5.1 AI 提问规范
当遇到需求模糊、多方案可选或可能存在风险的情况时，AI 应按以下方式响应：

列出可能的方案：简要描述各方案的优缺点。

请求确认：明确向用户提问，例如“请确认使用方案 A 还是 B，或提供更多背景信息”。

等待指令：在获得用户确认前，不要擅自执行方案。

### 5.2 变更记录
对于较大的功能添加或重构，请在 wiki/ 下适当更新文档（如 Overview.md），或创建新文档。

若项目使用 Git，AI 应在提交时生成符合 Conventional Commits 的提交信息，例如：

text
feat(hosts/brain-holder): 添加 docker 服务
fix(home-manager): 修正 root.nix 中的 zsh 配置路径
docs(wiki): 更新 Overview.md 中的模块说明

### 5.3 Git 提交规范
基于 Conventional Commits，但针对 NixOS 配置项目的结构进行定制，以提供更好的可读性和自动化工具兼容性。

**提交信息格式**
```
<type>: <short description>

[optional body]

[optional footer]
```

**类型 (type)**
- `feat`：新增功能或模块
- `fix`：修复错误
- `docs`：仅文档更改
- `style`：代码风格、格式化等（不影响功能）
- `refactor`：重构代码（既不修复错误也不添加功能）
- `test`：添加或修改测试
- `chore`：维护任务（构建、工具、依赖更新）
- `build`：构建系统或依赖项更改
- `perf`：性能优化
- `revert`：回滚之前的提交

**示例**
```
feat: add BEADS.md
fix: fix home-manager path err
docs: add AGENTS.md 
chore: update nixos 25.11
```

**注意事项**
- 提交信息使用英文
- 描述部分使用祈使句，现在时态（如“add”而非“added”）
- 正文部分可详细说明更改原因、影响范围等
- 页脚部分可用于引用 issue、Breaking Changes 等

### 5.4 约束与限制
禁止引入不稳定特性：除非明确要求，否则避免使用 NixOS 的 unstable 分支或处于实验阶段的选项。

保持精简：不随意添加不必要的依赖包，避免系统臃肿。

硬件相关配置：硬件配置（如显卡驱动、内核模块）应放在 modules/nixos/hardware/ 下，并尽量检测硬件自动加载，避免硬编码。

justfile 优先：如果 justfile 中已有对应命令（如 just rebuild、just test），优先使用这些命令而非原生命令，以确保一致性。

### 5.5 语言要求

所有与用户的交流、回复、提问、解释等，请使用中文，除非用户明确要求使用其他语言。

## 6. 测试与验证
在提交任何更改前，AI 应建议或自动执行以下验证：

语法检查：运行 nix-instantiate --parse <file> 或 nix eval --file <file> 检查语法错误。

构建测试：对受影响的主机运行 just dry-build <主机名> 或 nixos-rebuild dry-build --flake .#<主机名>，确保所有依赖可满足。

模块兼容性：如果修改了公共模块（如 modules/nixos/common/home-manager.nix），尝试用 nix eval .#nixosConfigurations.<主机名>.config 检查选项值是否正确合并。

## 7. 附则
本文件会随项目演进持续更新。AI 应定期查阅最新版本。

任何与本文件冲突的临时指令，请先与用户确认优先级。

如果你不确定某条规则是否适用，请主动提问。
