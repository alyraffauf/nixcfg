{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    cloudflare.file = "${self.inputs.secrets}/cloudflare.age";
    homepage.file = "${self.inputs.secrets}/homepage.age";
    k3s.file = "${self.inputs.secrets}/k3s.age";
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/slateport/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/slateport/key.age";
  };
}
