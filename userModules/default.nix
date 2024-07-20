self: {
  imports = [
    ./aly
    ./dustin
    ./options.nix
  ];

  users = {
    mutableUsers = false;

    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0HAmaMTAvrFrinB+b83c8hq6PyjmxRHg1IxR2GH6RN u0_a344@localhost" # termux on wallace
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGcJBb7+ZxkDdk06A0csNsbgT9kARUN185M8k3Lq7E/d u0_a336@localhost" # termux on winona
      (builtins.readFile ../secrets/publicKeys/aly_lavaridge.pub)
      (builtins.readFile ../secrets/publicKeys/aly_mauville.pub)
      (builtins.readFile ../secrets/publicKeys/aly_petalburg.pub)
      (builtins.readFile ../secrets/publicKeys/aly_rustboro.pub)
    ];
  };
}
