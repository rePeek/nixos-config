{ pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  environment.etc."rclone/rclone115.conf".text = ''
    [115]
    type = webdav
    url = http://127.0.0.1:5244/dav
    vendor = other
    user = admin
    pass = dCDL8qNCer2KmIBm7pj4oknSwfxKyg
  '';

  environment.systemPackages = [ pkgs.rclone ];

  systemd.tmpfiles.rules = [
    "d /mnt/rc115 0755 media media -"
  ];

  systemd.services.rclone115 = {
    description = "Rclone mount for 115 via OpenList";
    after = [
      "network-online.target"
      "openlist.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "openlist.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "notify";
      User = "media";
      Group = "media";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=/etc/rclone/rclone115.conf --allow-other --dir-perms 0555 --file-perms 0444 --vfs-cache-mode writes --ignore-checksum mount \"115:mnt/public_data/service/openlist/115/\" \"/mnt/rc115\"";
      ExecStop = "/run/wrappers/bin/fusermount -u /mnt/rc115";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
