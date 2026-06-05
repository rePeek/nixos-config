{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.openlist ];

  systemd.services.openlist = {
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
}
