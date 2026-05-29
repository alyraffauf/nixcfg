_: {
  sops.secrets = {
    rclone-b2 = {
      sopsFile = ../../secrets/rclone.yaml;
      key = "b2";
    };

    restic-passwd = {
      sopsFile = ../../secrets/restic.yaml;
      key = "password";
    };

    syncthingCert = {
      sopsFile = ../../secrets/syncthing/petalburg.yaml;
      key = "cert";
    };

    syncthingKey = {
      sopsFile = ../../secrets/syncthing/petalburg.yaml;
      key = "key";
    };

    tailscaleAuthKey = {
      sopsFile = ../../secrets/tailscale.yaml;
      key = "auth";
    };
  };
}
