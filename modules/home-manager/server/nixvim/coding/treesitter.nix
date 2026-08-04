# Treesitter — 语法高亮 + sticky scope（能力层）
# 通用工具语法；语言专属语法由各 lang/*.nix 声明
{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;

    settings = {
      highlight = {
        enable = true;
      };
      indent = {
        enable = true;
      };
    };

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      lua
      vim
      vimdoc
      query
    ];
  };

  # ── Treesitter Context (sticky scope) ──
  plugins.treesitter-context = {
    enable = true;
    settings = {
      max_lines = 3;
      min_window_height = 0;
      line_numbers = true;
    };
  };
}
