{
  # ── Leader ──
  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  # ── Editor Options ──
  opts = {
    number = true;
    relativenumber = true;

    shiftwidth = 4;
    tabstop = 4;
    softtabstop = 4;
    expandtab = true;
    smartindent = true;

    clipboard = "unnamedplus";
    signcolumn = "yes";
    cursorline = true;
    scrolloff = 8;

    mouse = "a";
    showmode = false;

    splitright = true;
    splitbelow = true;
    wrap = true;

    undofile = true;
    swapfile = false;

    ignorecase = true;
    smartcase = true;

    termguicolors = true;
  };

  # ── Auto Commands ──
  autoCmd = [
    # Highlight on yank
    {
      event = "TextYankPost";
      pattern = "*";
      callback = {
        __raw = "function() vim.highlight.on_yank() end";
      };
    }
    # Restore cursor position
    {
      event = "BufReadPost";
      pattern = "*";
      callback = {
        __raw = ''
          function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
              vim.api.nvim_win_set_cursor(0, mark)
            end
          end
        '';
      };
    }
  ];

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
