_: {
  networking = let
    hostName = "fortree";
  in {
    inherit hostName;
    computerName = hostName;
    localHostName = hostName;
  };
}
