# 颜色主题（纯外观，可随时替换）
{ lib, ... }:
{
  colorschemes.tokyonight = {
    enable = lib.mkDefault true;
    settings = {
      style = "storm";
    };
  };
}
