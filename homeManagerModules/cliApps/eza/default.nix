{ pkgs, lib, config, ... }: {

  options = { cliApps.eza.enable = lib.mkEnableOption "Enables eza."; };

  config = lib.mkIf config.cliApps.eza.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = true;
      extraOptions = [ "--group-directories-first" "--header" ];
    };
  };
}
