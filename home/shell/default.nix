{ config, pkgs, ... }:

{

    home.packages = with pkgs; [
        # backblaze-b2
        curl
        gh
        git
        nixfmt
        python3
        ruby
        wget
    ];

    programs.bash = {
        enable = true;
        enableCompletion = true;
        initExtra = ''
            export PS1="[\[$(tput setaf 27)\]\u\[$(tput setaf 135)\]@\[$(tput setaf 45)\]\h:\[$(tput setaf 33)\]\w] \[$(tput sgr0)\]$ "
        '';
    };

    programs.emacs = {
        enable = true;
        extraPackages = ( epkgs: (with epkgs; [
            better-defaults
            catppuccin-theme
            markdown-mode
            nix-mode
            org
            org-bullets
            org-journal
            org-roam     
            ox-pandoc
            projectile
            python
            treemacs
            treemacs-projectile
            treemacs-tab-bar
            use-package
            yaml
            yaml-mode
            ])
        );
        package = pkgs.emacs-nox;
        extraConfig = builtins.readFile ./emacs.el;
    };

    programs.eza = {
        enable = true;
        git = true;
        icons = true;
        extraOptions = [
            "--group-directories-first"
            "--header"
        ];
    };

    programs.fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
    };

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
    };

    programs.nnn.enable = true;

    programs.tmux = {
        enable = true;
        mouse = true;
        newSession = true;
        plugins = with pkgs; [
            tmuxPlugins.weather
            tmuxPlugins.better-mouse-mode
            tmuxPlugins.cpu
            tmuxPlugins.battery
            tmuxPlugins.resurrect
        ];
        terminal = "tmux-256color";
        extraConfig = ''
            set-option -g status-bg plum4
            set-option -g pane-active-border-style fg=plum4
            set-option -g @tmux-weather-format "%x+%t"
            set-option -g @tmux-weather-units "u"
            set -g status-right '#{cpu_percentage} CPU | #{battery_percentage} BAT | %I:%M %p | #{weather}'
            run-shell ${pkgs.tmuxPlugins.weather}/share/tmux-plugins/weather/tmux-weather.tmux
            run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
            run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux
            run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/resurrect/resurrect.tmux 
        '';
    };
}
