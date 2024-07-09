self: {
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./aly
    ./dustin
    ./morgan
    ./options.nix
  ];

  users = {
    mutableUsers = false;

    users.root.openssh.authorizedKeys.keyFiles = [
      ../secrets/publicKeys/aly_lavaridge.pub
      ../secrets/publicKeys/aly_mauville.pub
      ../secrets/publicKeys/aly_petalburg.pub
      ../secrets/publicKeys/aly_rustboro.pub
    ];
  };
}
