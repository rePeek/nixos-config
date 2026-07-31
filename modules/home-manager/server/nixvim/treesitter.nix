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
      cpp
      c
      rust
      nix
      bash
      python
      lua
      markdown
      markdown_inline
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
