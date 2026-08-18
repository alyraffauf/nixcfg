_: {
  flake.darwinModules.default = {
    config,
    lib,
    pkgs,
    self,
    ...
  }: {
    environment.etc."resolver/hoenn".text = "nameserver 10.254.1.1";

    sops.secrets.wireguard-hoenn-private = {
      sopsFile = self + "/secrets/wireguard-hoenn.yaml";
      key = "fortree";
    };

    networking.wg-quick.interfaces.hoenn = {
      address = ["10.254.1.5/24"];
      privateKeyFile = config.sops.secrets.wireguard-hoenn-private.path;
      preUp = ''
        while [ ! -r ${config.sops.secrets.wireguard-hoenn-private.path} ]; do
          /bin/sleep 1
        done
      '';

      peers = [
        {
          allowedIPs = ["10.254.1.0/24"];
          endpoint = "51.81.87.134:51821";
          persistentKeepalive = 25;
          publicKey = "vinYIK2laJ19yVMlw6iB5lb9+wY8ZBrM+Y4nrBmMxxQ=";
        }
      ];
    };

    # Backport nix-darwin#1738 so launchd waits for the Nix store to mount.
    launchd.daemons.wg-quick-hoenn.serviceConfig.ProgramArguments = lib.mkForce [
      "/bin/sh"
      "-c"
      "/bin/wait4path /nix/store && exec ${pkgs.wireguard-tools}/bin/wg-quick up hoenn"
    ];
  };
}
