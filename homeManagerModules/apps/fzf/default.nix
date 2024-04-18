{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {alyraffauf.apps.fzf.enable = lib.mkEnableOption "Enables fzf.";};

  config = lib.mkIf config.alyraffauf.apps.fzf.enable {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
  };
}
