{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    restic-passwd.file = "${self.inputs.secrets}/restic-password.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/slateport/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/slateport/key.age";
  };
}
