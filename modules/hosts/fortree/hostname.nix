_: {
  flake.darwinModules.fortree = {
    networking = let
      hostName = "fortree";
    in {
      inherit hostName;
      computerName = hostName;
      localHostName = hostName;
    };
  };
}
