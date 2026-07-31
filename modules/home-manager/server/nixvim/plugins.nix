{
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
  #  Completion — nvim-cmp + LuaSnip
  # ══════════════════════════════════════════════
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "buffer"; }
        { name = "path"; }
      ];
      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp_luasnip.enable = true;

  plugins.luasnip.enable = true;

  # ══════════════════════════════════════════════
  #  Multi-cursor — multicursors.nvim (Helix-style)
  # ══════════════════════════════════════════════
  plugins.multicursors = {
    enable = true;
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

  # ══════════════════════════════════════════════
  #  Which-Key (discoverable keymaps)
  # ══════════════════════════════════════════════
  plugins.which-key = {
    enable = true;
    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Find (Telescope)";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug (DAP)";
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
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
          mode = "n";
        }
        {
          __unkeyed-1 = "<leader>s";
          group = "Selection";
          mode = "n";
        }
      ];
    };
  };

  # ══════════════════════════════════════════════
  #  Keymaps
  # ══════════════════════════════════════════════
  keymaps = [
    # ══════════════════════════════════════════════
    #  Helix-style: Space + / for search
    # ══════════════════════════════════════════════
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

    # ══════════════════════════════════════════════
    #  Helix-style: Space + , for command palette
    # ══════════════════════════════════════════════
    {
      key = "<leader>,";
      mode = "n";
      action = "<cmd>Telescope commands<CR>";
      options = {
        desc = "Command palette";
      };
    }

    # ── Telescope (also Helix-style space+f prefix) ──
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

    # ══════════════════════════════════════════════
    #  Buffer Navigation — Helix-style
    # ══════════════════════════════════════════════
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

    # ── Window Navigation ──
    {
      key = "<C-h>";
      mode = "n";
      action = "<C-w>h";
      options = {
        desc = "Window left";
      };
    }
    {
      key = "<C-j>";
      mode = "n";
      action = "<C-w>j";
      options = {
        desc = "Window down";
      };
    }
    {
      key = "<C-k>";
      mode = "n";
      action = "<C-w>k";
      options = {
        desc = "Window up";
      };
    }
    {
      key = "<C-l>";
      mode = "n";
      action = "<C-w>l";
      options = {
        desc = "Window right";
      };
    }

    # ── Quick Save & Quit ──
    {
      key = "<leader>w";
      mode = "n";
      action = "<cmd>w<CR>";
      options = {
        desc = "Save";
      };
    }
    {
      key = "<leader>q";
      mode = "n";
      action = "<cmd>q<CR>";
      options = {
        desc = "Quit";
      };
    }
    {
      key = "<leader>Q";
      mode = "n";
      action = "<cmd>qall<CR>";
      options = {
        desc = "Quit all";
      };
    }

    # ── Move Lines (Helix-style) ──
    {
      key = "<A-j>";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>m .+1<CR>==";
      options = {
        desc = "Move line down";
      };
    }
    {
      key = "<A-k>";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>m .-2<CR>==";
      options = {
        desc = "Move line up";
      };
    }

    # ══════════════════════════════════════════════
    #  Helix-style: Selection enhancements
    #  (Keep Vim motions: ci" di( daw ciw yap etc.)
    # ══════════════════════════════════════════════
    {
      key = "<leader>ss";
      mode = "n";
      action = "viw";
      options = {
        desc = "Select word";
      };
    }
    {
      key = "<leader>sl";
      mode = "n";
      action = "V";
      options = {
        desc = "Select line";
      };
    }
    {
      key = "<leader>s%";
      mode = "n";
      action = "ggVG";
      options = {
        desc = "Select all";
      };
    }
    {
      key = "<leader>si";
      mode = "n";
      action = "vi(";
      options = {
        desc = "Select inside parens";
      };
    }
    {
      key = "<leader>sa";
      mode = "n";
      action = "va(";
      options = {
        desc = "Select around parens";
      };
    }
    {
      key = "<leader>si\"";
      mode = "n";
      action = "vi\"";
      options = {
        desc = "Select inside quotes";
      };
    }

    # ══════════════════════════════════════════════
    #  Helix-style: Go-to shortcuts (via Telescope)
    # ══════════════════════════════════════════════
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

    # ── Clear Search Highlight ──
    {
      key = "<Esc>";
      mode = "n";
      action = "<cmd>nohlsearch<CR>";
      options = {
        desc = "Clear search highlight";
      };
    }

    # ══════════════════════════════════════════════
    #  Visual mode enhancements (Helix-style)
    # ══════════════════════════════════════════════
    {
      key = "<";
      mode = "v";
      action = "<gv";
      options = {
        desc = "Indent left & reselect";
      };
    }
    {
      key = ">";
      mode = "v";
      action = ">gv";
      options = {
        desc = "Indent right & reselect";
      };
    }
    {
      key = "J";
      mode = "v";
      action = ":m '>+1<CR>gv=gv";
      options = {
        desc = "Move selection down";
      };
    }
    {
      key = "K";
      mode = "v";
      action = ":m '<-2<CR>gv=gv";
      options = {
        desc = "Move selection up";
      };
    }
  ];
}
