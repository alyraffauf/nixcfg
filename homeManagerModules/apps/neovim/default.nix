{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.neovim.enable = lib.mkEnableOption "Enables neovim.";};

  config = lib.mkIf config.alyraffauf.apps.neovim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
}
