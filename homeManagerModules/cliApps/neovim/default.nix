{ pkgs, lib, config, ... }: {

  options = { cliApps.neovim.enable = lib.mkEnableOption "Enables neovim."; };

  config = lib.mkIf config.cliApps.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
