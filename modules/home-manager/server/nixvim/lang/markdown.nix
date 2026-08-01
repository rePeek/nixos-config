{
  # ── LSP: marksman ──
  plugins.lsp.servers.marksman = {
    enable = true;
  };

  # ── Formatter: prettierd ──
  plugins.conform-nvim.settings.formatters_by_ft = {
    markdown = [ "prettierd" ];
  };
}
