{ pkgs, ... }:

{
  plugins.lsp = {
    enable = true;

    keymaps = {
      lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
        "<leader>ca" = "code_action";
        "<leader>rn" = "rename";
      };
      diagnostic = {
        "<leader>cd" = "open_float";
        "[d" = "goto_prev";
        "]d" = "goto_next";
      };
    };

    servers = {
      # ── C/C++ ──
      clangd = {
        enable = true;
        extraOptions = {
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=never"
          ];
        };
      };

      # ── Rust ──
      rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };

      # ── Nix ──
      nil_ls = {
        enable = true;
      };

      # ── Python ──
      pyright = {
        enable = true;
      };

      # ── Markdown ──
      marksman = {
        enable = true;
      };
    };
  };

  # ── Conform (Formatter) ──
  plugins.conform-nvim = {
    enable = true;
    settings = {
      default_format_opts = {
        lsp_format = "fallback";
        async = true;
      };
      formatters_by_ft = {
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];
      };
    };
  };

  # ── Which-Key groups ──
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>l";
      group = "LSP";
      mode = "n";
    }
  ];
}
