{ pkgs, ... }:
{
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages =  with pkgs;[
        proton-ge-bin
      ];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
    };

    gamemode.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\${HOME}/.steam/root/compatibilitytools.d";
  };
}
