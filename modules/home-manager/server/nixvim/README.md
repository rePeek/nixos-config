# Nixvim

基于 [nixvim](https://github.com/nix-community/nixvim) 的 Neovim 声明式配置，通过 Home Manager 集成。

## 设计原则

**UI 与能力分层**：功能插件（不可见的引擎）和 UI 插件（可见的外观）解耦，方便未来替换组件。

| 层 | 职责 | 替换成本 |
|----|------|----------|
| **core/** | 编辑器基础行为（opts、autocmds、基础键映射） | 几乎不换 |
| **ui/** | 外观层（主题、statusline、通知、诊断面板、Markdown 渲染） | 低，随时可换 |
| **editor/** | 编辑工具（搜索、文件浏览、跳转、文本操作） | 中，换实现不改引擎 |
| **coding/** | 编码引擎（LSP、补全、格式化、调试、语法高亮） | 中，换实现不改 UI |
| **git/** | Git 集成（gitsigns、lazygit） | 低 |
| **lang/** | 语言专属配置（LSP server + formatter + DAP + grammar） | 按语言独立增减 |

核心原则：
- **每个模块自带 keymaps + which-key 分组**，不集中散落。
- **lang/*.nix** 只放语言工具链的 server/formatter/DAP/grammar，不放基础设施。
- **extraPackages 不使用** — formatter 和 LSP server 需在 Home Manager 的 `home.packages` 中显式安装。
- **Treesitter grammar** 语言专属在各 `lang/*.nix`，`coding/treesitter.nix` 只保留通用工具 grammar。

## 目录结构

```
nixvim/
├── default.nix              # 入口，import 所有子模块
│
├── core/                    # 编辑器基础（不可见行为）
│   ├── options.nix          # leader、vim opts、autocmds、auto-save
│   └── keymaps.nix          # 基础 Vim 键映射（保存、退出、窗口、跳转）
│
├── ui/                      # 外观层（随时可换）
│   ├── theme.nix            # 颜色主题
│   ├── statusline.nix       # lualine + web-devicons
│   ├── noice.nix            # 命令行/消息 UI + which-key 基础设施 + indent-blankline
│   ├── diagnostics.nix      # Trouble 诊断面板
│   └── markdown.nix         # render-markdown
│
├── editor/                  # 编辑工具（功能插件，有 UI 但重点在功能）
│   ├── telescope.nix        # Telescope 模糊搜索
│   ├── oil.nix              # Oil 文件浏览器
│   ├── buffers.nix          # Buffer 导航
│   ├── flash.nix            # Flash 快速跳转
│   └── text.nix             # surround、comment、autopairs、multicursor、选区、行移动
│
├── coding/                  # 编码引擎（不可见的能力）
│   ├── lsp.nix              # LSP 基础设施 + 通用键映射
│   ├── completion.nix       # nvim-cmp + LuaSnip
│   ├── conform.nix          # 格式化引擎
│   ├── dap.nix              # DAP 调试器 + dap-ui
│   └── treesitter.nix       # 语法高亮 + treesitter-context
│
├── git/                     # Git 集成
│   ├── gitsigns.nix         # Gitsigns inline 标记
│   └── lazygit.nix          # LazyGit 浮动终端
│
└── lang/                    # 语言专属配置
    ├── default.nix          # 聚合导入
    ├── cc.nix               # C/C++：clangd + clang-format + codelldb
    ├── nix.nix              # Nix：nil_ls + nixfmt
    ├── python.nix           # Python：pyright + ruff/isort + codelldb
    └── markdown.nix         # Markdown：marksman + prettierd
```

## 快捷键速查

`<leader>` = 空格。

### 通用（core/keymaps.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>w` | n | 保存 |
| `<leader>q` | n | 退出 |
| `<leader>Q` | n | 全部退出 |
| `<C-h/j/k/l>` | n | 窗口切换 |
| `<C-Left>` | n | 跳回（jumplist back） |
| `<C-Right>` | n | 跳前（jumplist forward） |
| `<Esc>` | n | 清除搜索高亮 |

### Telescope / Find（editor/telescope.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader> ` | n | Find files（fuzzy） |
| `<leader>/` | n | Live grep（fuzzy） |
| `<leader>,` | n | Command palette |
| `<leader>ff` | n | Find files |
| `<leader>fg` | n | Live grep |
| `<leader>fb` | n | Buffers |
| `<leader>fh` | n | Help tags |
| `<leader>fr` | n | Recent files |
| `<leader>fs` | n | Grep cursor 下的字符串 |
| `<leader>fd` | n | Diagnostics |
| `<leader>fk` | n | Keymaps |

### Buffer（editor/buffers.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<S-h>` | n | 上一个 buffer |
| `<S-l>` | n | 下一个 buffer |
| `<leader>bc` | n | 关闭 buffer |
| `<leader>bx` | n | 强制关闭 buffer |
| `<leader>bo` | n | 关闭其他所有 buffer |
| `<leader>bl` | n | 列出 buffers（Telescope） |
| `<leader>bn` | n | 新建 buffer |
| `<leader>gf` | n | Git files |
| `<leader>gj` | n | Jumplist |
| `<leader>gm` | n | Marks |

### Explorer（editor/oil.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>e` | n | Oil 文件浏览器 |
| `-` | n | Oil（Helix 风格） |

### LSP（coding/lsp.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gd` | n | 跳转定义 |
| `gD` | n | 跳转引用 |
| `gt` | n | 跳转类型定义 |
| `gi` | n | 跳转实现 |
| `K` | n | Hover 文档 |
| `grr` | n | LSP references（Telescope） |
| `<leader>ca` | n | Code action |
| `<leader>rn` | n | 重命名 |
| `<leader>cd` | n | 打开诊断浮窗 |
| `[d` / `]d` | n | 上/下一个诊断 |

### Debug / DAP（coding/dap.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>db` | n | 切换断点 |
| `<leader>dc` | n | 继续 |
| `<leader>dn` | n | Step over |
| `<leader>ds` | n | Step into |
| `<leader>do` | n | Step out |
| `<leader>dr` | n | 重启 |
| `<leader>dt` | n | 终止 |
| `<leader>du` | n | 切换 DAP UI |

### Flash 快速跳转（editor/flash.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `s` | n, x, o | Flash 跳转（输入字符定位） |
| `S` | n, x, o | Flash 反向跳转 |
| `r` | o | Flash remote |
| `R` | x, o | Flash treesitter |

### Surround（editor/text.nix — mini.surround）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gsa` | n | 添加包裹 |
| `gsd` | n | 删除包裹 |
| `gsr` | n | 替换包裹 |
| `gsf` | n | 查找右侧包裹 |
| `gsF` | n | 查找左侧包裹 |
| `gsh` | n | 高亮包裹 |
| `gsn` | n | 更新行数 |

### Comment（editor/text.nix — mini.comment）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gcc` | n | 注释当前行 |
| `gc` | v | 注释选区 |

### Selection（editor/text.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>ss` | n | 选词 |
| `<leader>sl` | n | 选行 |
| `<leader>s%` | n | 全选 |
| `<leader>si` | n | 选括号内 |
| `<leader>sa` | n | 选括号及周围 |
| `<leader>si"` | n | 选引号内 |

### Move Lines（editor/text.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<A-j>` | n, v | 下移当前行 |
| `<A-k>` | n, v | 上移当前行 |

### Visual Mode（editor/text.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<` | v | 左缩进并保持选中 |
| `>` | v | 右缩进并保持选中 |
| `J` | v | 下移选区 |
| `K` | v | 上移选区 |

### Trouble / Diagnostics（ui/diagnostics.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>xx` | n | 切换 diagnostics 面板 |
| `<leader>xX` | n | 切换当前 buffer 的 diagnostics |
| `<leader>xl` | n | 切换 location list |
| `<leader>xq` | n | 切换 quickfix list |
| `<leader>xs` | n | 切换 symbols |
| `<leader>xr` | n | 切换 LSP references |

### Git（git/）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>gg` | n | LazyGit（git/lazygit.nix） |
| `<leader>gh` | n | Preview hunk（git/gitsigns.nix） |
| `<leader>gd` | n | Diff this |
| `<leader>gb` | n | Blame line |
| `]c` | n | 下一个 hunk |
| `[c` | n | 上一个 hunk |

## 自动保存

通过 `auto-save.nvim` 实现（core/options.nix），触发时机：

- `BufLeave` / `FocusLost` → 立即保存
- `InsertLeave` → 延迟保存（自动防抖）

无需手动 `<leader>w`，但快捷键仍保留作为手动保存入口。

## 添加新语言

1. 在 `lang/` 下创建 `<lang>.nix`：

```nix
{ pkgs, ... }:
{
  # LSP
  plugins.lsp.servers.<server_name> = {
    enable = true;
  };

  # Formatter
  plugins.conform-nvim.settings.formatters_by_ft = {
    <filetype> = [ "<formatter_name>" ];
  };

  # DAP（可选）
  plugins.dap.configurations.<lang> = [
    {
      name = "<Lang>: Launch file";
      type = "codelldb";
      request = "launch";
      program = "\${file}";
      cwd = "\${workspaceFolder}";
      stopOnEntry = false;
    }
  ];

  # Treesitter grammar
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    <lang>
  ];
}
```

2. 在 `lang/default.nix` 中添加 `./<lang>.nix`。
3. 确保 LSP server 和 formatter 工具已在 `home.packages` 中安装。

## 替换组件

由于 UI 和能力分层，替换组件只需改对应文件：

| 想换什么 | 改哪个文件 | 不动什么 |
|----------|-----------|----------|
| Telescope → snacks.picker | `editor/telescope.nix` | 所有 coding/、ui/、lang/ |
| nvim-cmp → blink.cmp | `coding/completion.nix` | 所有 ui/、editor/、lang/ |
| lualine → 其他 statusline | `ui/statusline.nix` | 所有 coding/、editor/、lang/ |
| tokyonight → 其他主题 | `ui/theme.nix` | 其他所有文件 |
| trouble.nvim → 其他诊断面板 | `ui/diagnostics.nix` | coding/lsp.nix、lang/ |
