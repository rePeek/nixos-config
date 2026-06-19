{ ... }:
{
  networking = {
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
      "114.114.114.114"
    ];
    proxy = {
      default = "http://home-server:7890";
      allProxy = "socks5://home-server:7890";
      noProxy = "127.0.0.1,localhost,::1,home-server,*.local,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.64.0.0/10";
    };
    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };
}
