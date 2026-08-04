# Buffer 导航（不依赖特定 UI 插件，纯 Neovim 内置命令 + Telescope buffers）
{
  keymaps = [
    {
      key = "<S-h>";
      mode = "n";
      action = "<cmd>bprevious<CR>";
      options.desc = "Previous buffer";
    }
    {
      key = "<S-l>";
      mode = "n";
      action = "<cmd>bnext<CR>";
      options.desc = "Next buffer";
    }
    {
      key = "<leader>bc";
      mode = "n";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
    {
      key = "<leader>bx";
      mode = "n";
      action = "<cmd>bdelete!<CR>";
      options.desc = "Force close buffer";
    }
    {
      key = "<leader>bo";
      mode = "n";
      action = "<cmd>%bdelete|e#<CR>";
      options.desc = "Close all other buffers";
    }
    {
      key = "<leader>bl";
      mode = "n";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "List buffers";
    }
    {
      key = "<leader>bn";
      mode = "n";
      action = "<cmd>enew<CR>";
      options.desc = "New buffer";
    }

    # Go-to shortcuts (via Telescope)
    {
      key = "<leader>gf";
      mode = "n";
      action = "<cmd>Telescope git_files<CR>";
      options.desc = "Git files";
    }
    {
      key = "<leader>gj";
      mode = "n";
      action = "<cmd>Telescope jumplist<CR>";
      options.desc = "Jumplist";
    }
    {
      key = "<leader>gm";
      mode = "n";
      action = "<cmd>Telescope marks<CR>";
      options.desc = "Marks";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffer";
      mode = "n";
    }
  ];
}
