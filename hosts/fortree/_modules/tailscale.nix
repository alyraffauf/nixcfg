_: {
  networking.search = ["narwhal-snapper.ts.net"];

  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };
}
