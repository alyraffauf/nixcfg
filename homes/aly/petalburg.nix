{...}: {
  home = {
    stateVersion = "24.11";
    username = "aly";
    homeDirectory = "/var/home/aly/";
  };

  ar.home = {
    apps = {
      shell.enable = true;
      vsCodium.enable = true;
      fastfetch.enable = true;
    };
  };
}
