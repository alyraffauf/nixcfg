{self, ...}: {
  age.secrets = {
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    k3s.file = "${self.inputs.secrets}/k3s.age";

    # lastfmId = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/lastfm/api.age";
    # };

    # lastfmSecret = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/lastfm/secret.age";
    # };

    slskd.file = "${self.inputs.secrets}/slskd.age";

    # spotifyId = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/spotify/client-id.age";
    # };

    # spotifySecret = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/spotify/client-secret.age";
    # };

    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/mauville/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/mauville/key.age";
    transmission.file = "${self.inputs.secrets}/transmission.age";
  };
}
