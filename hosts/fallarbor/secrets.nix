{self, ...}: {
  age.secrets = {
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/fallarbor/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/fallarbor/key.age";
  };
}
