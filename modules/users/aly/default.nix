{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./syncthing.nix];

  config = lib.mkIf config.ar.users.aly.enable {
    users.users.aly = {
      description = "Aly Raffauf";
      extraGroups = config.ar.users.defaultGroups;
      hashedPassword = config.ar.users.aly.password;
      isNormalUser = true;

      openssh.authorizedKeys = {
        keyFiles =
          lib.map (file: ../../../secrets/publicKeys + "/${file}")
          (lib.filter (file: lib.hasPrefix "aly_" file)
            (builtins.attrNames (builtins.readDir ../../../secrets/publicKeys)));

        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
        ];
      };

      shell = pkgs.zsh;
      uid = 1000;
    };
  };
}
