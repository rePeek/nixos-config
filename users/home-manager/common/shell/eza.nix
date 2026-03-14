{
  programs.eza = {
    enable = true;
  };

  home.shellAliases = {
    ls = "eza";
    l = "eza -lhg";
    ll = "eza -alhg";
    lt = "eza --tree";
  };
}
