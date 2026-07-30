# Nixvim 编辑器，直接使用 github:rePeek/nvim 的构建产物
{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.nvim.packages.${pkgs.system}.default
  ];
}
