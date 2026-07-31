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
    wrap = false;

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
}
