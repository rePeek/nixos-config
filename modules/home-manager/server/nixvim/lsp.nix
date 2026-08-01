{
  plugins.lsp = {
    enable = true;

    keymaps = {
      lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
        "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
      };
      diagnostic = {
        "<leader>cd" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };
  };

  # ── Conform (Formatter) ──
  plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts = {
        lsp_format = "fallback";
        async = true;
      };
    };
  };

  # ── Which-Key groups ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>l";
      group = "LSP";
      mode = "n";
    }
  ];
}
