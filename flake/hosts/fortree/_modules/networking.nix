_: {
  networking = let
    hostName = "fortree";
  in {
    inherit hostName;
    applicationFirewall.enable = true;
    computerName = hostName;
    localHostName = hostName;
  };
}
