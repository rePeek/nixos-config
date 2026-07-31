{ lib, ... }:
{
  colorschemes.tokyonight = {
    enable = lib.mkDefault true;
    settings = {
      style = "storm";
    };
  };
}
