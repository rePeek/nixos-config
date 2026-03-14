{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "nvidia" ];
    };

    displayManager = {
      autoLogin = {
        enable = true; # 禁用自动登录
        user = "asen";
      };
    };

    libinput = {
      enable = true;
    };
  };

  # To prevent getting stuck at shutdown
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
