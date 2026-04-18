{ ... }:
let
  lanIf = "enp1s0";
  lanIp = "192.168.50.1";
in
{
  services.dnsmasq = {
    enable = true;

    settings = {
      interface = lanIf;
      bind-interfaces = true;

      dhcp-range = [
        "192.168.50.100,192.168.50.200,255.255.255.0,12h"
      ];

      dhcp-option = [
        "3,${lanIp}" # 默认网关
        "6,${lanIp}" # DNS
      ];

      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      server = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };
}
