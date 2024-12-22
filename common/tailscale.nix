{config, ...}: {
  age.secrets.tailscaleAuthKey.file = ../secrets/tailscale/authKeyFile.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscaleAuthKey.path;
    openFirewall = true;
  };
}
