{ pkgs, ... }:
{
  # ── LSP: clangd ──
  plugins.lsp.servers.clangd = {
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

  # ── Formatter: clang-format ──
  plugins.conform-nvim.settings.formatters_by_ft = {
    c = [ "clang_format" ];
    cpp = [ "clang_format" ];
  };

  # ── DAP: C/C++ launch ──
  plugins.dap.configurations.cpp = [
    {
      name = "C/C++: Launch file";
      type = "codelldb";
      request = "launch";
      program = "\${fileDirname}/\${fileBasenameNoExtension}";
      cwd = "\${workspaceFolder}";
      stopOnEntry = false;
    }
  ];

  # ── Treesitter ──
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    c
    cpp
  ];
}
