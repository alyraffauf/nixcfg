_: {
  flake.homeModules.aly = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;

      flags = [
        "--disable-up-arrow"
      ];
    };
  };
}
