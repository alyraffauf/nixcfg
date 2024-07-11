{
  pkgs,
  lib,
  config,
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
        run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
        run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
        run-shell ${pkgs.tmuxPlugins.weather}/share/tmux-plugins/weather/tmux-weather.tmux
        set -g status-right '#{cpu_percentage} CPU | #{battery_percentage} BAT | %I:%M %p | #{weather}'
        set-option -g @tmux-weather-format "%x+%t"
        set-option -g @tmux-weather-units "u"
        set-option -g pane-active-border-style fg=plum4
        set-option -g status-bg plum4
      '';
    };
  };
}
