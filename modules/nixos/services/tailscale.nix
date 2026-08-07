_: {
  flake.nixosModules.default = {config, ...}: {
    networking.firewall = {
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = [config.services.tailscale.interfaceName];
    };

    services.tailscale = {
      enable = true;
      extraUpFlags = ["--ssh" "--accept-routes"];
      openFirewall = true;
      useRoutingFeatures = "both";
    };
  };
}
