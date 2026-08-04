# Trouble — 结构化 Diagnostics 面板（UI 层）
# 只管诊断的展示面板，诊断收集能力在 coding/lsp.nix
{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true;
      auto_open = false;
    };
  };

  # ── Keymaps ──
  keymaps = [
    {
      key = "<leader>xx";
      mode = "n";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Toggle diagnostics";
    }
    {
      key = "<leader>xX";
      mode = "n";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "Toggle buffer diagnostics";
    }
    {
      key = "<leader>xl";
      mode = "n";
      action = "<cmd>Trouble loclist toggle<CR>";
      options.desc = "Toggle location list";
    }
    {
      key = "<leader>xq";
      mode = "n";
      action = "<cmd>Trouble qflist toggle<CR>";
      options.desc = "Toggle quickfix list";
    }
    {
      key = "<leader>xs";
      mode = "n";
      action = "<cmd>Trouble symbols toggle<CR>";
      options.desc = "Toggle symbols";
    }
    {
      key = "<leader>xr";
      mode = "n";
      action = "<cmd>Trouble lsp_references toggle<CR>";
      options.desc = "Toggle LSP references";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>x";
      group = "Diagnostics (Trouble)";
      mode = "n";
    }
  ];
}
