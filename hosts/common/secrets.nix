{
  pkgs,
  self,
  ...
}: {
  age.secrets = {
    tailscaleAuthKey.file = ../../secrets/tailscale/authKeyFile.age;
    wifi.file = ../../secrets/wifi.age;
  };

  environment.systemPackages = [self.inputs.agenix.packages.${pkgs.system}.default];
}
