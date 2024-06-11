{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.eza.enable {
    programs.eza = {
      enable = true;
      extraOptions = ["--group-directories-first" "--header"];
      git = true;
      icons = true;
    };
  };
}
