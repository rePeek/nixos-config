let
  keys = {
    # 机器 host key：用于机器部署时自动解密
    sumatran = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRAK0LmI5aiJRMpg4eLpFgHCfbhKuR2iOlvvfuTxeGy root@sumatran";
    bengal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwB+A3F8bNyaqyzwB5b1W4CZ2e3vEJ1ePeIHmPQf+gC root@bengal";
    amur = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeec8Jqg5BwomYqZsmBCAlM+AY4AFf4q8A9x6GlbPax root@amur";
  };
  groups = {
    all = [
      keys.sumatran
      keys.bengal
      keys.amur
    ];
    development = [
      keys.amur
      keys.bengal
    ];
    # 显式列出可解密 mihomo 控制密钥的主机，避免 all 组新增成员时被动扩散。
    mihomo = [
      keys.bengal
      keys.amur
      keys.sumatran
    ];
  };

  mkSecret = publicKeys: {
    inherit publicKeys;
  };

in
{
  "jms-subscription.age" = mkSecret groups.all;
  "rc115-conf-pass.age" = mkSecret groups.all;
  "gpg-signing-key.age" = mkSecret groups.development;
  "mihomo-controller-secret.age" = mkSecret groups.mihomo;
}
