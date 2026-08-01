# Nixvim 编辑器配置（内联模式，替代原 github:rePeek/nvim standalone 包）
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      ./nixvim/default.nix
      ./nixvim/theme.nix
      ./nixvim/completion.nix
      ./nixvim/finder.nix
      ./nixvim/editing.nix
      ./nixvim/lsp.nix
      ./nixvim/treesitter.nix
      ./nixvim/dap.nix
      ./nixvim/git.nix
      ./nixvim/ui.nix
    ];
  };
}
