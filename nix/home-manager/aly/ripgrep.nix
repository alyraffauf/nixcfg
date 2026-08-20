_: {
  flake.homeModules.aly = {
    programs.ripgrep = {
      enable = true;
      arguments = ["--pretty"];
    };

    programs.ripgrep-all.enable = true;
  };
}
