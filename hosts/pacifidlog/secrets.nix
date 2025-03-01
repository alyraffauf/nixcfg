{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/pacifidlog/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/pacifidlog/key.age";
  };
}
