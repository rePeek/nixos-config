{ pkgs, ... }:
{
  systemd.services.openlist = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "openlist";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openlist}/bin/OpenList server";
      WorkingDirectory = "/mnt/public_data/service/openlist";
      Restart = "on-failure";
    };
  };
}
