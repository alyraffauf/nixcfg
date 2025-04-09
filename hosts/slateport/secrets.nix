{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    cloudflare.file = "${self.inputs.secrets}/cloudflare.age";
    homepage.file = "${self.inputs.secrets}/homepage.age";
    k3s.file = "${self.inputs.secrets}/k3s.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    slskd.file = "${self.inputs.secrets}/slskd.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/slateport/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/slateport/key.age";
  };
}
