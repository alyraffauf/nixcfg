_: {
  flake.darwinModules.default = {
    config,
    self,
    ...
  }: {
    environment.etc.hosts.text = ''
      ##
      # Host Database
      ##
      127.0.0.1 localhost
      255.255.255.255 broadcasthost
      ::1 localhost

      10.254.1.1 pastoria.hoenn
      10.254.1.2 mauville.hoenn
      10.254.1.3 rustboro.hoenn
      10.254.1.4 sootopolis.hoenn
      10.254.1.5 fortree.hoenn
    '';

    sops.secrets.wireguard-hoenn-private = {
      sopsFile = self + "/secrets/wireguard-hoenn.yaml";
      key = "fortree";
    };

    networking.wg-quick.interfaces.wg-hoenn = {
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
