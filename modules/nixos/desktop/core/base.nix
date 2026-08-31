{
  pkgs,
  ...
}:
{
  config = {
    # Required by GTK/GNOME applications and Home Manager dconf settings.
    programs.dconf.enable = true;

    services = {
      libinput.enable = true; # Enable touchpad, mouse and keyboard input handling.
      printing.enable = true; # Enable CUPS to print documents.
      geoclue2.enable = true; # Enable geolocation services.
      gvfs.enable = true;
      udev.packages = with pkgs; [
        gnome-settings-daemon
        # platformio # udev rules for platformio
        # openocd # required by paltformio, see https://github.com/NixOS/nixpkgs/issues/224895
        # openfpgaloader
      ];
    };
  };
}
