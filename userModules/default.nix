self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./aly
    ./dustin
    ./options.nix
  ];

  users = {
    mutableUsers = false;

    users.root.openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0HAmaMTAvrFrinB+b83c8hq6PyjmxRHg1IxR2GH6RN u0_a344@localhost" # termux on wallace
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
      ];

      keyFiles = [
        ../secrets/publicKeys/aly_lavaridge.pub
        ../secrets/publicKeys/aly_mauville.pub
        ../secrets/publicKeys/aly_petalburg.pub
        ../secrets/publicKeys/aly_rustboro.pub
      ];
    };
  };
}
