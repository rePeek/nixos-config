# Nixvim 编辑器配置
#
# 架构：UI / 能力分层
#   core/    — 编辑器基础行为（opts、autocmds、基础键映射）
#   ui/      — 外观层（主题、statusline、通知、诊断面板）
#   editor/  — 编辑工具（搜索、文件浏览、跳转、文本操作）
#   coding/  — 编码引擎（LSP、补全、格式化、调试、语法高亮）
#   git/     — Git 集成
#   lang/    — 语言专属配置（LSP server + formatter + DAP + grammar）
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      # ── Core: 编辑器基础 ──
      ./core/options.nix
      ./core/keymaps.nix

      # ── UI: 外观层 ──
      ./ui/theme.nix
      ./ui/statusline.nix
      ./ui/noice.nix
      ./ui/diagnostics.nix
      ./ui/markdown.nix

      # ── Editor: 编辑工具 ──
      ./editor/telescope.nix
      ./editor/oil.nix
      ./editor/buffers.nix
      ./editor/flash.nix
      ./editor/text.nix

      # ── Coding: 编码引擎 ──
      ./coding/lsp.nix
      ./coding/completion.nix
      ./coding/conform.nix
      ./coding/dap.nix
      ./coding/treesitter.nix

      # ── Git: Git 集成 ──
      ./git/gitsigns.nix
      ./git/lazygit.nix

      # ── Language: 语言专属 ──
      ./lang
    ];
  };
}
