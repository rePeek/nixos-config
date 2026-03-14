{ pkgs, ... }:
{
  home.packages = [ pkgs.rclone ];
  xdg.configFile."rclone/rclone.conf".text = ''
    [115]
    type = webdav
    url = http://127.0.0.1:5244/dav
    vendor = other
    user = admin
    pass = dCDL8qNCer2KmIBm7pj4oknSwfxKyg
  '';

  systemd.user.services.rclone115 = {
    Unit = {
      Description = "Example programmatic mount configuration with nix and home-manager.";
      Requires = [ "openlist.service" ];
      After = [
        "openlist.service"
        "network-online.target"
      ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/mnt115";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=%h/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount \"115:mnt/public_data/service/openlist/115/\" \"%h/mnt115\"";
      ExecStop = "/run/wrappers/bin/fusermount -u %h/mnt115/%i";
    };
    Install.WantedBy = [ "default.target" ];
  };

}
