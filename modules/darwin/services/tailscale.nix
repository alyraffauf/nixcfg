_: {
  flake.darwinModules.default = {
    networking = {
      # Explicitly manage these
      knownNetworkServices = [
        "Wi-Fi"
        "Ethernet Adaptor"
        "Thunderbolt Ethernet"
      ];

      # Otherwise tailscale ssh only works with FQDNs
      search = ["narwhal-snapper.ts.net"];
    };

    services.tailscale = {
      enable = true;
      # Needs a declared DNS provider in Tailscale's admin panel
      overrideLocalDns = true;
    };
  };
}
