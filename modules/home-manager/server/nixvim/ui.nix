{
  # ══════════════════════════════════════════════
  #  Lualine — Status line
  # ══════════════════════════════════════════════
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [ "filename" ];
        lualine_x = [
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
    };
  };

  # ══════════════════════════════════════════════
  #  Web Devicons
  # ══════════════════════════════════════════════
  plugins.web-devicons.enable = true;

  # ══════════════════════════════════════════════
  #  Noice — Better cmdline & messages UI
  # ══════════════════════════════════════════════
  plugins.noice = {
    enable = true;
    settings = {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = false;
        lsp_doc_border = true;
      };
      routes = [
        {
          filter = {
            event = "msg_show";
          };
          view = "mini";
        }
        {
          filter = {
            event = "notify";
            kind = "warn";
          };
          view = "mini";
        }
        {
          filter = {
            event = "notify";
            kind = "error";
          };
          view = "mini";
        }
      ];
    };
  };

  # ══════════════════════════════════════════════
  #  Which-Key (discoverable keymaps)
  # ══════════════════════════════════════════════
  plugins.which-key = {
    enable = true;
  };

  # ══════════════════════════════════════════════
  #  Indent Blankline
  # ══════════════════════════════════════════════
  plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "│";
      };
      scope = {
        enabled = true;
      };
    };
  };
}
