{
  # ══════════════════════════════════════════════
  #  Gitsigns — inline git decorations
  # ══════════════════════════════════════════════
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = true;
      current_line_blame_opts = {
        virt_text = true;
        delay = 500;
      };
    };
  };

  # ══════════════════════════════════════════════
  #  Lazygit — floating git terminal
  # ══════════════════════════════════════════════
  plugins.lazygit = {
    enable = true;
  };

  # ── Git Keymaps ──
  keymaps = [
    {
      key = "<leader>gg";
      mode = "n";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit";
      };
    }
    {
      key = "<leader>gh";
      mode = "n";
      action = {
        __raw = "function() require('gitsigns').preview_hunk() end";
      };
      options = {
        desc = "Preview hunk";
      };
    }
    {
      key = "<leader>gd";
      mode = "n";
      action = {
        __raw = "function() require('gitsigns').diffthis() end";
      };
      options = {
        desc = "Diff this";
      };
    }
    {
      key = "<leader>gb";
      mode = "n";
      action = {
        __raw = "function() require('gitsigns').blame_line() end";
      };
      options = {
        desc = "Blame line";
      };
    }
    {
      key = "]c";
      mode = "n";
      action = {
        __raw = "function() require('gitsigns').next_hunk() end";
      };
      options = {
        desc = "Next hunk";
      };
    }
    {
      key = "[c";
      mode = "n";
      action = {
        __raw = "function() require('gitsigns').prev_hunk() end";
      };
      options = {
        desc = "Previous hunk";
      };
    }
  ];
}
