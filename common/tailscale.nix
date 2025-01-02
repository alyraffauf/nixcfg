{config, ...}: {
  age.secrets.tailscaleAuthKey.file = ../secrets/tailscale/authKeyFile.age;

  networking.firewall = {
    allowedUDPPorts = [config.services.tailscale.port];
    trustedInterfaces = [config.services.tailscale.interfaceName];
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscaleAuthKey.path;
    openFirewall = true;
  };
}
