# 文本编辑工具：surround、comment、autopairs、multicursor、选区、行移动
{
  # ══════════════════════════════════════════════
  #  Mini.pairs — 自动括号配对
  # ══════════════════════════════════════════════
  plugins.mini-pairs = {
    enable = true;
    settings = {
      modes = {
        insert = true;
        command = true;
        terminal = false;
      };
    };
  };

  # ══════════════════════════════════════════════
  #  Mini.surround — 增删改括号/引号包裹
  # ══════════════════════════════════════════════
  plugins.mini-surround = {
    enable = true;
    settings = {
      mappings = {
        add = "gsa";
        delete = "gsd";
        find = "gsf";
        find_left = "gsF";
        highlight = "gsh";
        replace = "gsr";
        update_n_lines = "gsn";
      };
      # s/S 让给 flash，surround 通过 gsa/gsd/gsr/gsh 前缀操作
    };
  };

  # ══════════════════════════════════════════════
  #  Mini.comment — 注释切换
  # ══════════════════════════════════════════════
  plugins.mini-comment = {
    enable = true;
    settings = {
      options = {
        customCommentString = "";
        ignoreBlankLine = true;
        startOfLine = false;
      };
      mappings = {
        comment = "gcc";
        commentLine = "gcc";
        commentVisual = "gc";
        textobject = "gc";
      };
    };
  };

  # ══════════════════════════════════════════════
  #  Multi-cursor — multicursors.nvim (Helix-style)
  # ══════════════════════════════════════════════
  plugins.multicursors = {
    enable = true;
  };

  # ── Keymaps ──
  keymaps = [
    # ── Selection enhancements ──
    {
      key = "<leader>ss";
      mode = "n";
      action = "viw";
      options.desc = "Select word";
    }
    {
      key = "<leader>sl";
      mode = "n";
      action = "V";
      options.desc = "Select line";
    }
    {
      key = "<leader>s%";
      mode = "n";
      action = "ggVG";
      options.desc = "Select all";
    }
    {
      key = "<leader>si";
      mode = "n";
      action = "vi(";
      options.desc = "Select inside parens";
    }
    {
      key = "<leader>sa";
      mode = "n";
      action = "va(";
      options.desc = "Select around parens";
    }
    {
      key = "<leader>si\"";
      mode = "n";
      action = "vi\"";
      options.desc = "Select inside quotes";
    }

    # ── Move Lines (Helix-style) ──
    {
      key = "<A-j>";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>m .+1<CR>==";
      options.desc = "Move line down";
    }
    {
      key = "<A-k>";
      mode = [
        "n"
        "v"
      ];
      action = "<cmd>m .-2<CR>==";
      options.desc = "Move line up";
    }

    # ── Visual mode enhancements ──
    {
      key = "<";
      mode = "v";
      action = "<gv";
      options.desc = "Indent left & reselect";
    }
    {
      key = ">";
      mode = "v";
      action = ">gv";
      options.desc = "Indent right & reselect";
    }
    {
      key = "J";
      mode = "v";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      key = "K";
      mode = "v";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }
  ];

  # ── Which-Key ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "gs";
      group = "Surround";
      mode = "n";
    }
    {
      __unkeyed-1 = "<leader>s";
      group = "Selection";
      mode = "n";
    }
  ];
}
