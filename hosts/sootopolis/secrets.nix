{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/authKeyFile.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/sootopolis/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/sootopolis/key.age";
  };
}
