{ ... }:
{
  services = {
    daed = {
      enable = true;

      openFirewall = {
        enable = true;
        port = 12345;
      };

      configDir = "/etc/dae-wing";
      listen = "127.0.0.1:2023";
    };
  };
}
