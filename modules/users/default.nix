{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./aly
    ./dustin
    ./options.nix
  ];

  config = lib.mkIf (config.myUsers.root.enable or config.myUsers.aly.enable or config.myUsers.dustin.enable) {
    programs = {
      fish.enable = true;
      zsh.enable = true;
    };

    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = false;

      users.root.openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: lib.hasPrefix "aly_" file)
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));
    };
  };
}
