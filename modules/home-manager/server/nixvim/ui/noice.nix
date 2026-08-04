# Noice — 命令行/消息/通知 UI + Which-Key 基础设施 + Indent Blankline
{
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
  #  Which-Key (discoverable keymaps) — 基础设施
  #  各模块通过 spec 追加自己的分组
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
