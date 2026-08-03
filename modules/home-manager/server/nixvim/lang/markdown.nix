{ pkgs, ... }:
{
  # ── LSP: marksman ──
  plugins.lsp.servers.marksman = {
    enable = true;
  };

  # ── Formatter: prettierd ──
  plugins.conform-nvim.settings.formatters_by_ft = {
    markdown = [ "prettierd" ];
  };

  # ── Treesitter ──
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    markdown
    markdown_inline
  ];
}
