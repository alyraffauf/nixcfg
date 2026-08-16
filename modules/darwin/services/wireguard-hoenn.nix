_: {
  flake.darwinModules.default = {
    config,
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

      peers = [
        {
          allowedIPs = ["10.254.1.0/24"];
          endpoint = "51.81.87.134:51821";
          persistentKeepalive = 25;
          publicKey = "vinYIK2laJ19yVMlw6iB5lb9+wY8ZBrM+Y4nrBmMxxQ=";
        }
      ];
    };
  };
}
