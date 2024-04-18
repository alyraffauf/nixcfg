{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.eza.enable = lib.mkEnableOption "Enables eza.";};

  config = lib.mkIf config.alyraffauf.apps.eza.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = true;
      extraOptions = ["--group-directories-first" "--header"];
    };
  };
}
