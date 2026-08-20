_: {
  flake.homeModules.aly = {
    programs.zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
  };
}
