{ pkgs, ... }:
{
  # ── LSP: pyright ──
  plugins.lsp.servers.pyright = {
    enable = true;
  };

  # ── Formatter: ruff + isort ──
  plugins.conform-nvim.settings.formatters_by_ft = {
    python = [
      "isort"
      "ruff_format"
    ];
  };

  # ── DAP: Python launch ──
  plugins.dap.configurations.python = [
    {
      name = "Python: Launch file";
      type = "codelldb";
      request = "launch";
      program = "\${file}";
      cwd = "\${workspaceFolder}";
      stopOnEntry = false;
    }
  ];

  # ── Treesitter ──
  plugins.treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    python
  ];
}
