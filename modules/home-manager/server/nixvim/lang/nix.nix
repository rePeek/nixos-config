{
  # ── LSP: nil ──
  plugins.lsp.servers.nil_ls = {
    enable = true;
  };

  # ── Formatter: nixfmt ──
  plugins.conform-nvim.settings.formatters_by_ft = {
    nix = [ "nixfmt" ];
  };
}
