# Core desktop profile: system services shared by graphical sessions.
{
  imports = [
    ./audio.nix
    ./base.nix
    ./bluetooth.nix
    ./fonts.nix
    ./graphics.nix
    ./input-method.nix
    ./network.nix
    ./wayland.nix
  ];
}
