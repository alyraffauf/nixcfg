{
  config,
  self,
  ...
}: {
  age.secrets = {
    rclone-b2.file = "${self.inputs.secrets}/rclone/b2.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/key.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
  };
}
