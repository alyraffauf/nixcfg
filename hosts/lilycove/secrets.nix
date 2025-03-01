{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/lilycove/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/lilycove/key.age";
  };
}
