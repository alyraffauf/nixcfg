_: {
  flake.nixosModules.wireguardHoenn = {
    config,
    pkgs,
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
      firewall.trustedInterfaces = ["hoenn"];

      wireguard.interfaces.hoenn = {
        ips = ["${nodeAddress}/24"];
        privateKeyFile = config.sops.secrets.wireguard-hoenn-private.path;
        postSetup = ''
          ${pkgs.systemd}/bin/resolvectl dns hoenn 10.254.1.1
          ${pkgs.systemd}/bin/resolvectl domain hoenn ~hoenn
          ${pkgs.systemd}/bin/resolvectl default-route hoenn false
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
    };

    services.resolved.enable = true;

    systemd.services.wireguard-hoenn.after = ["systemd-resolved.service"];
  };
}
