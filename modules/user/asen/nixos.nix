# Shared system account profile for the asen user.
{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.custom.users.asen;
  gpgFingerprint = "F8D6A23D561E28EC2EB23E8FB8CF115BCA7F8C1A";
  hasDesktopAvatar = lib.hasAttrByPath [
    "custom"
    "desktop"
    "avatar"
    "users"
  ] options;
in
{
  options.custom.users.asen = {
    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional groups for the asen system account on this host.";
    };
  };

  config = lib.mkIf (lib.elem "asen" config.custom.users.enabled) (
    {
      users.users.asen = {
        isNormalUser = true;
        description = "asen";
        home = "/home/asen";
        extraGroups = cfg.extraGroups;
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = config.custom.ssh.sharedAuthorizedKeys;
      };

      programs.fish.enable = true;

      age.secrets.gpg-signing-key = {
        file = ../../../secrets/gpg-signing-key.age;
        owner = "asen";
        mode = "0400";
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        settings = {
          default-cache-ttl = 43200;
          max-cache-ttl = 43200;
        };
      };

      systemd.services.gpg-import-signing-key = {
        description = "Import GPG signing key for asen";

        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = "asen";

          Environment = [
            "HOME=/home/asen"
            "GNUPGHOME=/home/asen/.gnupg"
          ];
        };

        script = ''
          mkdir -p "$GNUPGHOME"
          chmod 700 "$GNUPGHOME"

          if ! ${pkgs.gnupg}/bin/gpg \
            --list-secret-keys "${gpgFingerprint}" >/dev/null 2>&1
          then
            ${pkgs.gnupg}/bin/gpg \
              --batch \
              --import ${config.age.secrets.gpg-signing-key.path}
          fi
        '';
      };

      # Allow the user's flakes and command-line invocations to opt into extra substituters.
      nix.settings = {
        trusted-users = [ "asen" ];
        allowed-users = [ "asen" ];
      };
    }
    // lib.optionalAttrs hasDesktopAvatar {
      custom.desktop.avatar.users.asen = lib.mkDefault ../../../assets/avatars/asen.jpg;
    }
  );
}
