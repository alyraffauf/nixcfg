{ pkgs, lib, config, ... }: {

  options = { cliApps.tmux.enable = lib.mkEnableOption "Enables tmux."; };

  config = lib.mkIf config.cliApps.tmux.enable {
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
        set-option -g status-bg plum4
        set-option -g pane-active-border-style fg=plum4
        set-option -g @tmux-weather-format "%x+%t"
        set-option -g @tmux-weather-units "u"
        set -g status-right '#{cpu_percentage} CPU | #{battery_percentage} BAT | %I:%M %p | #{weather}'
        run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
        run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux 
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
        run-shell ${pkgs.tmuxPlugins.weather}/share/tmux-plugins/weather/tmux-weather.tmux
      '';
    };
  };
}
