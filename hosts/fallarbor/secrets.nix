_: {
  sops.secrets = {
    syncthingCert = {
      sopsFile = ../../secrets/syncthing/fallarbor.yaml;
      key = "cert";
    };

    syncthingKey = {
      sopsFile = ../../secrets/syncthing/fallarbor.yaml;
      key = "key";
    };
  };
}
