let
  # 机器 host key：用于机器部署时自动解密
  home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1tDbCxa8MbbUAAFDcvjVY+y8ULjLjL0tK78QWbtwJ root@home-server";
  brain-holder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX1IacqcOcccRKWpGVIZ55jLT0m9PdD7jS5EOyGQK6a root@nixos";
in
{
  "flybit-subscription.age".publicKeys = [
    home-server
    brain-holder
  ];
  "dream-subscription.age".publicKeys = [
    home-server
    brain-holder
  ];
  "jms-subscription.age".publicKeys = [
    home-server
    brain-holder
  ];
}
