# Core desktop profile: system services shared by graphical sessions.
{
  imports = [
    ./base.nix
    ./fonts.nix
    ./wayland.nix
  ];
}
