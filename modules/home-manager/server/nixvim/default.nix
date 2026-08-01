# Nixvim 编辑器配置（内联模式，替代原 github:rePeek/nvim standalone 包）
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      ./options.nix
      ./keymaps.nix
      ./theme.nix
      ./completion.nix
      ./finder.nix
      ./editing.nix
      ./lsp.nix
      ./treesitter.nix
      ./dap.nix
      ./git.nix
      ./ui.nix
    ];
  };
}
