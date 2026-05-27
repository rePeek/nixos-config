let
  keys = {
    # 机器 host key：用于机器部署时自动解密
    home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1tDbCxa8MbbUAAFDcvjVY+y8ULjLjL0tK78QWbtwJ root@home-server";
    brain-holder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX1IacqcOcccRKWpGVIZ55jLT0m9PdD7jS5EOyGQK6a root@nixos";
    blue-10700 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwB+A3F8bNyaqyzwB5b1W4CZ2e3vEJ1ePeIHmPQf+gC root@Blue-10700";
  };
  groups = {
    all = [
      keys.home-server
      keys.brain-holder
      keys.blue-10700
    ];
  };

  mkSecret = publicKeys: {
    inherit publicKeys;
  };

in
{
  "dream-subscription.age" = mkSecret groups.all;
  "jms-subscription.age" = mkSecret groups.all;
  "ydy-subscription.age" = mkSecret groups.all;
}
