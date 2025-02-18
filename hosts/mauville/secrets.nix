{
  age.secrets = {
    rclone-b2.file = ../../secrets/rclone/b2.age;
    tailscaleAuthKey.file = ../../secrets/tailscale/authKeyFile.age;
    k3s.file = ../../secrets/k3s.age;

    lastfmId = {
      owner = "navidrome";
      file = ../../secrets/lastFM/apiKey.age;
    };

    lastfmSecret = {
      owner = "navidrome";
      file = ../../secrets/lastFM/secret.age;
    };

    spotifyId = {
      owner = "navidrome";
      file = ../../secrets/spotify/clientId.age;
    };

    spotifySecret = {
      owner = "navidrome";
      file = ../../secrets/spotify/clientSecret.age;
    };

    syncthingCert.file = ../../secrets/aly/syncthing/mauville/cert.age;
    syncthingKey.file = ../../secrets/aly/syncthing/mauville/key.age;
    transmission.file = ../../secrets/transmission.age;
  };
}
