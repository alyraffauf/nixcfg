_: {
  sops.secrets = {
    tailscaleAuthKey = {
      sopsFile = ../../secrets/tailscale.yaml;
      key = "auth";
    };

    syncthingCert = {
      sopsFile = ../../secrets/syncthing/pacifidlog.yaml;
      key = "cert";
    };

    syncthingKey = {
      sopsFile = ../../secrets/syncthing/pacifidlog.yaml;
      key = "key";
    };
  };
}
