_: {
  networking = {
    knownNetworkServices = [
      "Wi-Fi"
      "Ethernet Adaptor"
      "Thunderbolt Ethernet"
    ];

    search = ["narwhal-snapper.ts.net"];
  };

  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };
}
