# Flash — 快速跳转（s + 字符定位）
{
  plugins.flash = {
    enable = true;
    settings = {
      labels = "asdfghjklqwertyuiopzxcvbnm";
      modes = {
        char = {
          enabled = false;
        };
      };
    };
  };

  # ── Keymaps ──
  keymaps = [
    {
      key = "s";
      mode = [
        "n"
        "x"
        "o"
      ];
      action = {
        __raw = "function() require('flash').jump() end";
      };
      options.desc = "Flash jump";
    }
    {
      key = "S";
      mode = [
        "n"
        "x"
        "o"
      ];
      action = {
        __raw = "function() require('flash').jump({ search = { forward = false } }) end";
      };
      options.desc = "Flash jump (backward)";
    }
    {
      key = "r";
      mode = "o";
      action = {
        __raw = "function() require('flash').remote() end";
      };
      options.desc = "Flash remote";
    }
    {
      key = "R";
      mode = [
        "x"
        "o"
      ];
      action = {
        __raw = "function() require('flash').treesitter() end";
      };
      options.desc = "Flash treesitter";
    }
  ];
}
