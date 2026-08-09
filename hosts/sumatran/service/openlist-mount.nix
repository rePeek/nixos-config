# OpenList WebDAV service and its local rclone mount.
{ config, pkgs, ... }:
{
  programs.fuse.userAllowOther = true;

  networking.firewall.allowedTCPPorts = [ 5244 ];

  age.secrets.rc115-conf-pass = {
    file = ../../../secrets/rc115-conf-pass.age;
    owner = "media";
    group = "media";
    mode = "0400";
  };

  environment.systemPackages = [ pkgs.openlist ];

  systemd = {
    tmpfiles.rules = [
      "d /mnt/rc115 0750 media media -"
      "d /srv/media/local 0750 media media -"
      "d /srv/media/local/comics 0750 media media -"
      "d /srv/media/local/videos 0750 media media -"
    ];

    services = {
      openlist = {
        description = "OpenList";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = "media";
          Group = "media";
          WorkingDirectory = "/var/lib/openlist";
          ExecStart = "${pkgs.openlist}/bin/OpenList server";
          Restart = "on-failure";
          StateDirectory = "openlist";
        };
      };

      rclone115 = {
        description = "Rclone mount for 115 via OpenList";
        path = [ "/run/wrappers" ];
        preStart = ''
          umask 077
          {
            echo '[115]'
            echo 'type = webdav'
            echo 'url = http://127.0.0.1:5244/dav'
            echo 'vendor = other'
            echo 'user = admin'
            printf 'pass = '
            cat ${config.age.secrets.rc115-conf-pass.path}
          } > "$RUNTIME_DIRECTORY/rclone115.conf"
        '';
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
          RuntimeDirectory = "rclone115";
          RuntimeDirectoryMode = "0700";
          ExecStart = "${pkgs.rclone}/bin/rclone mount \"115:/115/\" \"/mnt/rc115\" --config=/run/rclone115/rclone115.conf --allow-other --dir-perms=0750 --file-perms=0640 --vfs-cache-mode=off --ignore-checksum";
          ExecStop = "/run/wrappers/bin/fusermount -u /mnt/rc115";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
