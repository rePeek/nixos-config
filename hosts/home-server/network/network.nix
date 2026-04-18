{ ... }:
let
  wanIf = "enp3s0";
  lanIf = "enp1s0";
  lanIp = "192.168.50.1";
in
{
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "114.114.114.114"
    ];

    # 让 LAN 口有固定地址
    interfaces.${lanIf}.ipv4.addresses = [
      {
        address = lanIp;
        prefixLength = 24;
      }
    ];

    # 开 NAT，让 LAN 设备能通过 WAN 出网
    nat = {
      enable = true;
      externalInterface = wanIf;
      internalInterfaces = [ lanIf ];
    };

    firewall = {
      enable = true;

      # LAN 口可以直接信任，省掉很多内网拦截问题
      trustedInterfaces = [ lanIf ];

      allowedTCPPorts = [
        22
        # dae
        2023
        # ragflow
        49385
        # openclaw
        18789
        18790
        # mihomo
        7890
        9090

        53
        7890
      ];

      allowedUDPPorts = [
        53
        67
        68
      ];
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
}
