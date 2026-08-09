{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "malayan";

  imports = [
    ./hardware
    ./network.nix

    ./derper.nix
    ./my-derper.nix

    ../../modules/nixos/core
  ];

  custom = {
    boot.mode = "bios";
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  users.users.root.openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;

  environment.systemPackages = [ pkgs.openssl ];
}
