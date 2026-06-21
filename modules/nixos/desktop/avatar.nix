# Avatar component with AccountsService integration.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.desktop.avatar;
  desktopUsers = config.custom.desktop.users;
  configuredUsers = lib.attrNames cfg.users;
  invalidUsers = lib.filter (username: !(lib.elem username desktopUsers)) configuredUsers;
  storeAvatars = lib.mapAttrs (
    username: avatar:
    builtins.path {
      path = avatar;
      name = "${username}-avatar";
    }
  ) cfg.users;

  installAccountsServiceAvatar =
    username: avatar:
    let
      source = lib.escapeShellArg (toString avatar);
      iconPath = "${cfg.iconsDirectory}/${username}";
      userFile = "${cfg.usersDirectory}/${username}";
    in
    ''
      icon_path=${lib.escapeShellArg iconPath}
      user_file=${lib.escapeShellArg userFile}

      ${pkgs.coreutils}/bin/install -Dm0644 ${source} "$icon_path"

      tmp_file="$(${pkgs.coreutils}/bin/mktemp)"
      if [ -f "$user_file" ] && ${pkgs.gnugrep}/bin/grep -q '^\[User\]$' "$user_file"; then
        ${pkgs.gawk}/bin/awk -v icon="$icon_path" '
          BEGIN {
            inUser = 0
            sawUser = 0
            setIcon = 0
          }
          $0 == "[User]" {
            sawUser = 1
            inUser = 1
            print
            next
          }
          /^\[/ {
            if (inUser && !setIcon) {
              print "Icon=" icon
              setIcon = 1
            }
            inUser = 0
          }
          inUser && /^Icon=/ {
            if (!setIcon) {
              print "Icon=" icon
              setIcon = 1
            }
            next
          }
          { print }
          END {
            if (!sawUser) {
              print "[User]"
              print "Icon=" icon
            } else if (inUser && !setIcon) {
              print "Icon=" icon
            }
          }
        ' "$user_file" > "$tmp_file"
      else
        {
          printf '[User]\n'
          printf 'Icon=%s\n' "$icon_path"
        } > "$tmp_file"
      fi

      ${pkgs.coreutils}/bin/install -Dm0644 "$tmp_file" "$user_file"
      ${pkgs.coreutils}/bin/rm -f "$tmp_file"
    '';

  accountsServiceActivation = lib.concatStringsSep "\n" (
    lib.mapAttrsToList installAccountsServiceAvatar storeAvatars
  );
in
{
  options.custom.desktop.avatar = {
    enable = lib.mkEnableOption "desktop user avatars";

    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      description = "Avatar image paths keyed by desktop username.";
      example = lib.literalExpression ''
        {
          asen = ../../assets/avatars/asen.png;
        }
      '';
    };

    iconsDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/AccountsService/icons";
      description = "AccountsService icon directory.";
    };

    usersDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/AccountsService/users";
      description = "AccountsService user metadata directory.";
    };
  };

  config = lib.mkIf (config.custom.desktop.enable && cfg.enable) {
    assertions = [
      {
        assertion = invalidUsers == [ ];
        message =
          "custom.desktop.avatar.users contains users not listed in custom.desktop.users: "
          + lib.concatStringsSep ", " invalidUsers;
      }
    ];

    services.accounts-daemon.enable = true;

    system.extraDependencies = lib.attrValues storeAvatars;

    system.activationScripts.desktopAvatars = lib.mkIf (cfg.users != { }) {
      text = accountsServiceActivation;
    };
  };
}
