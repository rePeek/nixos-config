{
  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;

  # To prevent getting stuck at shutdown.
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
