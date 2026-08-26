{ inputs, pkgs, ... }:
{
  imports = [
    ../../modules/home-manager/server
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.username = "root";
  home.homeDirectory = "/root";

  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = {
      yaml = "${inputs.tinted-schemes}/base16/dracula.yaml";
      use-ifd = "always";
    };
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
