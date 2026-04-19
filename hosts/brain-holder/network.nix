{ pkgs, ... }:
{
  networking = {
    hostName = "brain-holder";
    networkmanager = {
      enable = true;
      # 这里使用自定义网口的原因是这个网口连着旁路由
      # 会导致 tailscale 网内连接变慢
      # 本机上已自动开启了 clash
      ensureProfiles.profiles."ethernet-no-default" = {
        connection = {
          id = "ethernet-no-default";
          type = "ethernet";
          interface-name = "enp5s0";
          autoconnect = true;
        };

        ipv4 = {
          method = "auto";
          never-default = true;
        };

        ipv6.method = "disabled";
      };
    };
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "114.114.114.114"
    ];
    firewall = {
      allowedTCPPorts = [
        22
        5244

        #jellyfin
        8096
      ];
      allowedUDPPorts = [
        #jellyfin
        7359
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
