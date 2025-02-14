{ pkgs, ... } : {
  home.packages = [ pkgs.openlist ];

  systemd.user.services.openlist = {
    Unit = {
      Description = "openlist";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.openlist}/bin/OpenList server";
      WorkingDirectory = "/mnt/public_data/service/openlist";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
