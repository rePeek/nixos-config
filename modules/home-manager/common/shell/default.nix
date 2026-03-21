{
  imports = [
    ./eza.nix
    ./nushell.nix
    ./fzf.nix
    ./yazi.nix
    ./zoxide.nix
  ];

  home = {
    shellAliases = import ./aliases.nix;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
