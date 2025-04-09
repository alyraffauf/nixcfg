{
  config,
  self,
  ...
}: {
  age.secrets = {
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/${config.networking.hostName}/key.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
  };
}
