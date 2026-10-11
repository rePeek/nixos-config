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
    boot.mode = "uefi";
  };

  services.openssh.settings.PermitRootLogin = lib.mkForce "prohibit-password";

  users.users.root.openssh.authorizedKeys.keys = lib.unique (
    [
      # Keep the installing host explicitly authorized after reinstalling.
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ43pkqashtye7OIr1TPJ2lJTwy2NCKotVspszQRY6tS asen@amur"
    ]
    ++ config.custom.ssh.sharedAuthorizedKeys
  );

  environment.systemPackages = [ pkgs.openssl ];
}
