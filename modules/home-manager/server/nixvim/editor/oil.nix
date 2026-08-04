# Oil.nvim — 文件浏览器
{
  plugins.oil = {
    enable = true;
    settings = {
      default_file_explorer = true;
      delete_to_trash = true;
      skip_confirm_for_simple_edits = true;
      view_options = {
        show_hidden = true;
      };
    };
  };

  # ── Keymaps ──
  keymaps = [
    {
      key = "<leader>e";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options.desc = "Oil file explorer";
    }
    {
      key = "-";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options.desc = "Oil (Helix-style dash)";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>e";
      group = "Explorer";
      mode = "n";
    }
  ];
}
