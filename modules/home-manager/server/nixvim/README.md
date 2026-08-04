# Nixvim

基于 [nixvim](https://github.com/nix-community/nixvim) 的 Neovim 声明式配置，通过 Home Manager 集成。

## 目录结构

```
nixvim/
├── default.nix        # 入口，import 所有子模块
├── options.nix        # 编辑器选项（缩进、剪贴板、光标等）+ auto-save.nvim
├── keymaps.nix        # 通用快捷键（保存、退出、窗口、跳转历史）
├── theme.nix          # 颜色主题
├── completion.nix     # 补全（nvim-cmp）
├── finder.nix         # 文件查找（Telescope）
├── editing.nix        # 编辑增强（flash、mini、trouble、multicursors）
├── lang.nix           # 语言基础设施：LSP + Conform + DAP 的插件启用、
│                      # keymaps 和 which-key 分组
├── lang/              # 语言专属配置（每个语言一个文件）
│   ├── default.nix    # 聚合导入
│   ├── cc.nix         # C/C++：clangd + clang-format + codelldb
│   ├── nix.nix        # Nix：nil_ls + nixfmt
│   ├── python.nix     # Python：pyright + ruff/isort + codelldb
│   └── markdown.nix   # Markdown：marksman + prettierd
├── treesitter.nix     # 语法高亮基础设置 + 通用工具 grammar（bash, lua, vim 等）
├── git.nix            # Git 集成（gitsigns 等）
└── ui.nix             # UI 组件（statusline、lualine 等）
```

## 设计原则

- **`lang.nix`** 只放语言工具链的通用基础设施（插件启用、全局 keymaps），不放具体语言的 server/formatter 配置。
- **`lang/<lang>.nix`** 每个文件集中声明一种语言的全部能力：LSP server、Conform formatter、DAP debug configuration。
- **`extraPackages` 不使用** — nixvim 不自动拉取外部工具包；formatter 和 LSP server 需在 Home Manager 的 `home.packages` 中显式安装。
- **Treesitter grammar** 语言专属 grammar 放在各 `lang/*.nix` 中，`treesitter.nix` 只保留通用工具 grammar（bash, lua, vim, vimdoc, query）。

## 快捷键速查

`<leader>` = 空格。

### 通用（keymaps.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>w` | n | 保存 |
| `<leader>q` | n | 退出 |
| `<leader>Q` | n | 全部退出 |
| `<C-h/j/k/l>` | n | 窗口切换 |
| `<C-Left>` | n | 跳回（jumplist back） |
| `<C-Right>` | n | 跳前（jumplist forward） |
| `<Esc>` | n | 清除搜索高亮 |

### Telescope / Find（finder.nix）

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
| `<leader>gf` | n | Git files |
| `<leader>gj` | n | Jumplist |
| `<leader>gm` | n | Marks |

### Buffer（finder.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<S-h>` | n | 上一个 buffer |
| `<S-l>` | n | 下一个 buffer |
| `<leader>bc` | n | 关闭 buffer |
| `<leader>bx` | n | 强制关闭 buffer |
| `<leader>bo` | n | 关闭其他所有 buffer |
| `<leader>bl` | n | 列出 buffers（Telescope） |
| `<leader>bn` | n | 新建 buffer |

### Explorer（finder.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>e` | n | Oil 文件浏览器 |
| `-` | n | Oil（Helix 风格） |

### LSP（lang.nix）

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

### Debug / DAP（lang.nix）

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

### Flash 快速跳转（editing.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `s` | n, x, o | Flash 跳转（输入字符定位） |
| `S` | n, x, o | Flash 反向跳转 |
| `r` | o | Flash remote |
| `R` | x, o | Flash treesitter |

### Surround（editing.nix — mini.surround）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gsa` | n | 添加包裹 |
| `gsd` | n | 删除包裹 |
| `gsr` | n | 替换包裹 |
| `gsf` | n | 查找右侧包裹 |
| `gsF` | n | 查找左侧包裹 |
| `gsh` | n | 高亮包裹 |
| `gsn` | n | 更新行数 |

### Comment（editing.nix — mini.comment）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `gcc` | n | 注释当前行 |
| `gc` | v | 注释选区 |

### Selection（editing.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>ss` | n | 选词 |
| `<leader>sl` | n | 选行 |
| `<leader>s%` | n | 全选 |
| `<leader>si` | n | 选括号内 |
| `<leader>sa` | n | 选括号及周围 |
| `<leader>si"` | n | 选引号内 |

### Move Lines（editing.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<A-j>` | n, v | 下移当前行 |
| `<A-k>` | n, v | 上移当前行 |

### Visual Mode（editing.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<` | v | 左缩进并保持选中 |
| `>` | v | 右缩进并保持选中 |
| `J` | v | 下移选区 |
| `K` | v | 上移选区 |

### Trouble / Diagnostics（editing.nix）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>xx` | n | 切换 diagnostics 面板 |
| `<leader>xX` | n | 切换当前 buffer 的 diagnostics |
| `<leader>xl` | n | 切换 location list |
| `<leader>xq` | n | 切换 quickfix list |
| `<leader>xs` | n | 切换 symbols |
| `<leader>xr` | n | 切换 LSP references |

### Git（git.nix — gitsigns + lazygit）

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>gg` | n | LazyGit |
| `<leader>gh` | n | Preview hunk |
| `<leader>gd` | n | Diff this |
| `<leader>gb` | n | Blame line |
| `]c` | n | 下一个 hunk |
| `[c` | n | 上一个 hunk |

## 自动保存

通过 `auto-save.nvim` 实现，触发时机：

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
