let
  keys = {
    # 机器 host key：用于机器部署时自动解密
    home-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICL1tDbCxa8MbbUAAFDcvjVY+y8ULjLjL0tK78QWbtwJ root@home-server";
    bengal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwB+A3F8bNyaqyzwB5b1W4CZ2e3vEJ1ePeIHmPQf+gC root@bengal";
    amur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeec8Jqg5BwomYqZsmBCAlM+AY4AFf4q8A9x6GlbPax root@amur";
  };
  groups = {
    all = [
      keys.home-server
      keys.bengal
      keys.amur
    ];
  };

  mkSecret = publicKeys: {
    inherit publicKeys;
  };

in
{
  "jms-subscription.age" = mkSecret groups.all;
  "yuetong-subscription.age" = mkSecret groups.all;
  "rc115-conf-pass.age" = mkSecret groups.all;
}
