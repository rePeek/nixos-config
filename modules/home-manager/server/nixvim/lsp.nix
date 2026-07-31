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

  # ── LSP UI tweaks ──
  plugins.lsp-format.enable = true;
}
