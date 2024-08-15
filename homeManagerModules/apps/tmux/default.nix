{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.tmux.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      newSession = true;

      plugins = with pkgs; [
        tmuxPlugins.battery
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.cpu
        tmuxPlugins.resurrect
        tmuxPlugins.weather
      ];

      terminal = "tmux-256color";

      extraConfig = ''
        set -g status-right '%I:%M %p '
      '';
    };
  };
}
