_: {
  flake.nixosModules.wireguardHoenn = {
    config,
    self,
    ...
  }: let
    nodes = {
      mauville = "10.254.1.2";
      rustboro = "10.254.1.3";
      sootopolis = "10.254.1.4";
      fallarbor = "10.254.1.6";
    };
    nodeAddress = nodes.${config.networking.hostName};
  in {
    sops.secrets.wireguard-hoenn-private = {
      sopsFile = self + "/secrets/wireguard-hoenn.yaml";
      key = config.networking.hostName;
      mode = "0400";
    };

    networking = {
      hosts = {
        "10.254.1.1" = ["pastoria.hoenn"];
        "10.254.1.2" = ["mauville.hoenn"];
        "10.254.1.3" = ["rustboro.hoenn"];
        "10.254.1.4" = ["sootopolis.hoenn"];
        "10.254.1.5" = ["fortree.hoenn"];
        "10.254.1.6" = ["fallarbor.hoenn"];
      };

      firewall.trustedInterfaces = ["wg-hoenn"];

      wireguard.interfaces.wg-hoenn = {
        ips = ["${nodeAddress}/24"];
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
  };
}
