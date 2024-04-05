{ pkgs, lib, config, ... }: {

  options = {
    cliApps.neofetch.enable = lib.mkEnableOption "Enable neofetch.";
  };

  config = lib.mkIf config.cliApps.neofetch.enable {

    home.packages = [ pkgs.neofetch ];
    xdg.configFile."neofetch/config.conf".source = ./config.conf;

  };
}
