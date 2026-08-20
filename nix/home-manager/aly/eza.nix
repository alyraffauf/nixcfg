_: {
  flake.homeModules.aly = {
    home.shellAliases = {
      l = "eza -lah";
      la = "eza -a";
      ll = "eza -l";
      lla = "eza -la";
      ls = "eza";
      lt = "eza --tree";
      tree = "eza --tree";
    };

    programs.eza = {
      enable = true;

      extraOptions = [
        "--group-directories-first"
        "--header"
      ];

      git = true;
      icons = "auto";
    };
  };
}
