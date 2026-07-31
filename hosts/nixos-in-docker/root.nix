{ inputs, ... }:
let
  base16Schemes = import ../../theme/base16-schemes.nix;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ../../modules/home-manager/server
  ];

  home.username = "root";
  home.homeDirectory = "/root";

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = base16Schemes.wolf-alabaster-dark;
    polarity = "dark";

    targets = {
      bat.enable = true;
      btop.enable = true;
      fish.enable = true;
      fzf.enable = true;
      helix.enable = true;
      lazygit.enable = true;
      nushell.enable = true;
      starship.enable = true;
      yazi.enable = true;
      zellij.enable = true;
    };
  };

  programs.git.settings.user = {
    name = "rePeek";
    email = "senxlin@gmail.com";
  };
}
