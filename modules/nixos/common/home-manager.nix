{ usernames, inputs, ... }:{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bkp";
    extraSpecialArgs = { inherit inputs; };
    users = builtins.listToAttrs (map (username: {
      name = username;
      value = import ../../../users/${username}/home.nix {
        inherit inputs;
      };
    }) usernames);
  };
}
