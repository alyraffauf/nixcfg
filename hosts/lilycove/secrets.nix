{self, ...}: {
  age.secrets = {
    # deluge = {
    #   file = "${self.inputs.secrets}/deluge.age";
    #   owner = "deluge";
    # };

    # lastfmId = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/lastfm/api.age";
    # };

    # lastfmSecret = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/lastfm/secret.age";
    # };

    # spotifyId = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/spotify/client-id.age";
    # };

    # spotifySecret = {
    #   owner = "navidrome";
    #   file = "${self.inputs.secrets}/spotify/client-secret.age";
    # };

    bazarrApiKey.file = "${self.inputs.secrets}/arr/bazarrApiKey.age";
    lidarrApiKey.file = "${self.inputs.secrets}/arr/lidarrApiKey.age";
    prowlarrApiKey.file = "${self.inputs.secrets}/arr/prowlarrApiKey.age";
    radarrApiKey.file = "${self.inputs.secrets}/arr/radarrApiKey.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    slskd.file = "${self.inputs.secrets}/slskd.age";
    sonarrApiKey.file = "${self.inputs.secrets}/arr/sonarrApiKey.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/lilycove/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/lilycove/key.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
  };
}
