{
  # ══════════════════════════════════════════════
  #  Fuzzy Finder — Telescope
  # ══════════════════════════════════════════════
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

  # ══════════════════════════════════════════════
  #  File Explorer — Oil.nvim
  # ══════════════════════════════════════════════
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

  # ══════════════════════════════════════════════
  #  render-markdown.nvim — Markdown 渲染
  # ══════════════════════════════════════════════
  plugins.render-markdown = {
    enable = true;
    settings = {
      render_modes = [
        "n"
        "c"
        "t"
      ];
      anti_conceal = {
        enabled = false;
      };
    };
  };

  # ── Keymaps ──
  keymaps = [
    # ── Telescope: Helix-style shortcuts ──
    {
      key = "<leader>/";
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      options = {
        desc = "Live grep (Helix space+/)";
      };
    }
    {
      key = "<leader> ";
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      options = {
        desc = "Find files (Helix space+space)";
      };
    }
    {
      key = "<leader>,";
      mode = "n";
      action = "<cmd>Telescope commands<CR>";
      options = {
        desc = "Command palette";
      };
    }

    # ── Telescope: standard prefix ──
    {
      key = "<leader>ff";
      mode = "n";
      action = "<cmd>Telescope find_files<CR>";
      options = {
        desc = "Find files";
      };
    }
    {
      key = "<leader>fg";
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      options = {
        desc = "Live grep";
      };
    }
    {
      key = "<leader>fb";
      mode = "n";
      action = "<cmd>Telescope buffers<CR>";
      options = {
        desc = "Buffers";
      };
    }
    {
      key = "<leader>fh";
      mode = "n";
      action = "<cmd>Telescope help_tags<CR>";
      options = {
        desc = "Help tags";
      };
    }
    {
      key = "<leader>fr";
      mode = "n";
      action = "<cmd>Telescope oldfiles<CR>";
      options = {
        desc = "Recent files";
      };
    }
    {
      key = "<leader>fs";
      mode = "n";
      action = "<cmd>Telescope grep_string<CR>";
      options = {
        desc = "Grep string under cursor";
      };
    }
    {
      key = "<leader>fd";
      mode = "n";
      action = "<cmd>Telescope diagnostics<CR>";
      options = {
        desc = "Diagnostics";
      };
    }
    {
      key = "<leader>fk";
      mode = "n";
      action = "<cmd>Telescope keymaps<CR>";
      options = {
        desc = "Keymaps";
      };
    }

    # ── Oil File Explorer ──
    {
      key = "<leader>e";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Oil file explorer";
      };
    }
    {
      key = "-";
      mode = "n";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Oil (Helix-style dash)";
      };
    }

    # ── Buffer Navigation ──
    {
      key = "<S-h>";
      mode = "n";
      action = "<cmd>bprevious<CR>";
      options = {
        desc = "Previous buffer";
      };
    }
    {
      key = "<S-l>";
      mode = "n";
      action = "<cmd>bnext<CR>";
      options = {
        desc = "Next buffer";
      };
    }
    {
      key = "<leader>bc";
      mode = "n";
      action = "<cmd>bdelete<CR>";
      options = {
        desc = "Close buffer (Helix space+x)";
      };
    }
    {
      key = "<leader>bx";
      mode = "n";
      action = "<cmd>bdelete!<CR>";
      options = {
        desc = "Force close buffer";
      };
    }
    {
      key = "<leader>bo";
      mode = "n";
      action = "<cmd>%bdelete|e#<CR>";
      options = {
        desc = "Close all other buffers";
      };
    }
    {
      key = "<leader>bl";
      mode = "n";
      action = "<cmd>Telescope buffers<CR>";
      options = {
        desc = "List buffers";
      };
    }
    {
      key = "<leader>bn";
      mode = "n";
      action = "<cmd>enew<CR>";
      options = {
        desc = "New buffer";
      };
    }

    # ── Go-to shortcuts (via Telescope) ──
    {
      key = "<leader>gf";
      mode = "n";
      action = "<cmd>Telescope git_files<CR>";
      options = {
        desc = "Git files";
      };
    }
    {
      key = "<leader>gj";
      mode = "n";
      action = "<cmd>Telescope jumplist<CR>";
      options = {
        desc = "Jumplist";
      };
    }
    {
      key = "<leader>gm";
      mode = "n";
      action = "<cmd>Telescope marks<CR>";
      options = {
        desc = "Marks";
      };
    }
  ];

  # ── Which-Key groups ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "Find (Telescope)";
      mode = "n";
    }
    {
      __unkeyed-1 = "<leader>e";
      group = "Explorer";
      mode = "n";
    }
    {
      __unkeyed-1 = "<leader>b";
      group = "Buffer";
      mode = "n";
    }
  ];
}
