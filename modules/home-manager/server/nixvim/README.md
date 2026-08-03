# Nixvim

基于 [nixvim](https://github.com/nix-community/nixvim) 的 Neovim 声明式配置，通过 Home Manager 集成。

## 目录结构

```
nixvim/
├── default.nix        # 入口，import 所有子模块
├── options.nix        # 编辑器选项（缩进、剪贴板、光标等）+ auto-save.nvim
├── keymaps.nix        # 通用快捷键（保存、退出、窗口、格式化）
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

### 通用

| 快捷键 | 模式 | 说明 |
|--------|------|------|
| `<leader>w` | n | 保存 |
| `<leader>q` | n | 退出 |
| `<leader>Q` | n | 全部退出 |
| `<leader>f` | n, v | 手动格式化（conform） |
| `<C-h/j/k/l>` | n | 窗口切换 |
| `<Esc>` | n | 清除搜索高亮 |

### LSP

| 快捷键 | 说明 |
|--------|------|
| `gd` | 跳转定义 |
| `gD` | 跳转引用 |
| `gt` | 跳转类型定义 |
| `gi` | 跳转实现 |
| `K` | Hover 文档 |
| `<leader>ca` | Code action |
| `<leader>rn` | 重命名 |
| `<leader>cd` | 打开诊断浮窗 |
| `[d` / `]d` | 上/下一个诊断 |

### DAP

| 快捷键 | 说明 |
|--------|------|
| `<leader>db` | 切换断点 |
| `<leader>dc` | 继续 |
| `<leader>dn` | Step over |
| `<leader>ds` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | 重启 |
| `<leader>dt` | 终止 |
| `<leader>du` | 切换 DAP UI |

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
