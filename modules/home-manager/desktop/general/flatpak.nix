# User-level Flatpak integration via nix-flatpak.
# NixOS provides the Flatpak infrastructure; this module enables
# declarative management of user Flatpak apps (~/.local/share/flatpak/).
{
  config,
  lib,
  ...
}:
{
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;

    update = {
      onActivation = false;

      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };

    packages = [
      "com.github.tchx84.Flatseal"
      "com.tencent.WeChat"
    ];
  };

  # Override nix-flatpak's activation to use --no-block so deploy doesn't wait
  # for Flatpak downloads to finish (they can take a long time on first install).
  home.activation.flatpak-managed-install = lib.mkForce (
    lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
      $DRY_RUN_CMD ${config.systemd.user.systemctlPath} is-system-running -q && \
        ${config.systemd.user.systemctlPath} --user start --no-block flatpak-managed-install.service || true
    ''
  );
}
