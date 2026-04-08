{
  hostName,
  usernames,
  inputs,
  ...
}:
{
  home-manager = {
    # 用系统的 pkgs（保证 overlay 生效）
    useGlobalPkgs = true;
    # 包安装到用户环境（PATH 正常）
    useUserPackages = true;
    backupFileExtension = "bkp";
    extraSpecialArgs = { inherit inputs; };
    users = builtins.listToAttrs (
      map (username: {
        name = username;
        value = import ../../hosts/${hostName}/users/${username}.nix {
          inherit inputs;
        };
      }) usernames
    );
  };
}
