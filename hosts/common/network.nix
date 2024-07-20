{config, ...}: {
  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [config.age.secrets.wifi.path];
      profiles = import ./wifi.nix;
    };
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscaleAuthKey.path;
    extraUpFlags = ["--ssh"];
    openFirewall = true;
  };
}
