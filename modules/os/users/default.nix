{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./aly
    ./dustin
    ./options.nix
  ];

  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    mutableUsers = false;

    users.root.openssh.authorizedKeys = {
      keyFiles =
        lib.map (file: ../../../secrets/publicKeys + "/${file}")
        (lib.filter (file: lib.hasPrefix "aly_" file)
          (builtins.attrNames (builtins.readDir ../../../secrets/publicKeys)));

      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGzc0kupJmNgdHK1FtPxJIe3dKtsuIScLXgHZU3ggVUN actions@github" # github actions
      ];
    };
  };
}
