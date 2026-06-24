{
  imports = [
    ./carapace.nix
    ./eza.nix
    ./fish.nix
    ./nushell.nix
    ./fzf.nix
    ./starship.nix
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
