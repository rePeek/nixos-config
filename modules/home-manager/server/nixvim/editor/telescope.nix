# Telescope — 模糊搜索能力（功能层）
# 插件配置 + 搜索相关 keymaps
{
  plugins.telescope = {
    enable = true;
    settings = {
      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^result/"
          "^node_modules/"
        ];
      };
    };
  };

  # ── Keymaps ──
  keymaps = [
    # Helix-style shortcuts
    {
      key = "<leader>/";
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      key = "<leader> ";
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files";
    }
    {
      key = "<leader>,";
      mode = "n";
      action = "<cmd>Telescope commands<CR>";
      options.desc = "Command palette";
    }

    # Standard prefix
    {
      key = "<leader>ff";
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files";
    }
    {
      key = "<leader>fg";
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      key = "<leader>fb";
      mode = "n";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "Buffers";
    }
    {
      key = "<leader>fh";
      mode = "n";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Help tags";
    }
    {
      key = "<leader>fr";
      mode = "n";
      action = "<cmd>Telescope oldfiles<CR>";
      options.desc = "Recent files";
    }
    {
      key = "<leader>fs";
      mode = "n";
      action = "<cmd>Telescope grep_string<CR>";
      options.desc = "Grep string under cursor";
    }
    {
      key = "<leader>fd";
      mode = "n";
      action = "<cmd>Telescope diagnostics<CR>";
      options.desc = "Diagnostics";
    }
    {
      key = "<leader>fk";
      mode = "n";
      action = "<cmd>Telescope keymaps<CR>";
      options.desc = "Keymaps";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "Find (Telescope)";
      mode = "n";
    }
  ];
}
