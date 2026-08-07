_: {
  networking = let
    hostName = "fortree";
  in {
    inherit hostName;
    applicationFirewall.enable = true;
    computerName = hostName;

    knownNetworkServices = [
      "Wi-Fi"
      "Ethernet Adaptor"
      "Thunderbolt Ethernet"
    ];

    localHostName = hostName;
    search = ["narwhal-snapper.ts.net"];
  };
}
