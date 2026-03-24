{
  hostName,
  usernames,
  inputs,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
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
