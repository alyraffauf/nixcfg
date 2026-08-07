_: {
  sops.secrets = {
    tailscaleAuthKey = {
      sopsFile = ../../secrets/tailscale.yaml;
      key = "auth";
    };

    syncthingCert = {
      sopsFile = ../../secrets/syncthing/sootopolis.yaml;
      key = "cert";
    };

    syncthingKey = {
      sopsFile = ../../secrets/syncthing/sootopolis.yaml;
      key = "key";
    };
  };
}
