{
  config,
  self,
  ...
}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/key.age";
  };
}
