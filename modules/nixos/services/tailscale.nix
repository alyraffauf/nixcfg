_: {
  flake.nixosModules.default = {
    config,
    self,
    ...
  }: {
    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    sops.secrets.tailscale-auth-key.sopsFile = self + "/secrets/tailscale.yaml";

    services.tailscale = {
      authKeyFile = config.sops.secrets.tailscale-auth-key.path;
      enable = true;
      extraUpFlags = ["--ssh" "--accept-routes"];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
  };
}
