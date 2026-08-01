{
  # ── Basic Keymaps (save, quit, window, misc) ──
  keymaps = [
    # ── Save & Quit ──
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
    # ── Format ──
    {
      key = "<leader>f";
      mode = [
        "n"
        "v"
      ];
      action = {
        __raw = "function() require('conform').format({ lsp_format = 'fallback' }) end";
      };
      options = {
        desc = "Format buffer";
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
  ];
}
