# Shared terminfo support and system shutdown defaults.
{ pkgs, ... }:
{
  # Support Ghostty SSH sessions without building every terminal emulator.
  environment.enableAllTerminfo = false;
  environment.systemPackages = [ pkgs.ghostty.terminfo ];

  # To prevent getting stuck at shutdown.
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
