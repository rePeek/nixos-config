{ ... }: {
  imports = [
    ./tui
    ./gui
    ./scripts/scripts.nix
    ./xdg-mimes.nix
  ];
  home = {  
    stateVersion = "24.11"; # Please read the comment before changing.  
  };

  programs.home-manager.enable = true;
}
