# LSP — 语言服务器基础设施（能力层）
# 只管 LSP 引擎和通用键映射，具体 server 在 lang/*.nix
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

  # ── Keymaps ──
  keymaps = [
    {
      key = "grr";
      mode = "n";
      action = "<cmd>Telescope lsp_references<CR>";
      options.desc = "LSP references (Telescope)";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>l";
      group = "LSP";
      mode = "n";
    }
  ];
}
