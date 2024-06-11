{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.fzf.enable {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
  };
}
