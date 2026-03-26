{ ... }:
{
  networking = {
    hostName = "home-server"; # Define your hostname.
    networkmanager.enable = false;
    useDHCP = false;

    # 为你的网卡（根据实际名称调整）启用 DHCP 获取 IP
    interfaces.enp3s0.useDHCP = true;

    # 强制默认网关为代理服务器
    defaultGateway = "192.168.0.116";

    # DNS 服务器（可选，覆盖 DHCP 下发的 DNS）
    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
  };
}
