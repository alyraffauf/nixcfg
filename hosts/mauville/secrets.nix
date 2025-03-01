{self, ...}: {
  age.secrets = {
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/authKeyFile.age";
    k3s.file = "${self.inputs.secrets}/k3s.age";

    lastfmId = {
      owner = "navidrome";
      file = "${self.inputs.secrets}/lastFM/apiKey.age";
    };

    lastfmSecret = {
      owner = "navidrome";
      file = "${self.inputs.secrets}/lastFM/secret.age";
    };

    spotifyId = {
      owner = "navidrome";
      file = "${self.inputs.secrets}/spotify/clientId.age";
    };

    spotifySecret = {
      owner = "navidrome";
      file = "${self.inputs.secrets}/spotify/clientSecret.age";
    };

    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/mauville/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/mauville/key.age";
    transmission.file = "${self.inputs.secrets}/transmission.age";
  };
}
