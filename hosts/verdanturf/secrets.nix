{self, ...}: {
  age.secrets = {
    cloudflare.file = "${self.inputs.secrets}/cloudflare.age";
    pds.file = "${self.inputs.secrets}/pds.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/authKeyFile.age";
    vaultwarden.file = "${self.inputs.secrets}/vaultwarden.age";
  };
}
