{ config, pkgs, ... }:

{
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
            org
            org-bullets
            org-journal
            org-roam     
            nix-mode
            treemacs
            treemacs-tab-bar
            treemacs-projectile
            projectile
            yaml
            yaml-mode
            markdown-mode
            ox-pandoc
            use-package
            python
            ])
        );
        package = pkgs.emacs-nox;
        extraConfig = ''
            ; 4 spaces > tabs.
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
            (setq indent-line-function 'insert-tab)

            ; xterm mouse mode
            (xterm-mouse-mode 1)

            ; Enable line numbers
            (global-display-line-numbers-mode 1)
            (global-hl-line-mode t)

            ; Enable mouse scrolling
            (global-set-key (kbd "<mouse-4>") 'previous-line)
            (global-set-key (kbd "<mouse-5>") 'next-line)

            ; Enable tabs
            (tab-bar-mode 1)
            (setq tab-bar-show 1)
            (setq tab-bar-new-tab-choice "*dashboard*")

            ; Enable treemacs
            (add-hook 'emacs-startup-hook 'treemacs)
            (treemacs-load-theme "Default")
            (setq treemacs-width 20)
            (treemacs-resize-icons 16) ; Adjust the icon size according to your preference
            (setq treemacs-follow-mode t) ; Enable follow mode
            (setq treemacs-filewatch-mode t) ; Enable file watch mode
            (setq treemacs-fringe-indicator-mode t) ; Enable fringe indicator mode
            (setq treemacs-git-mode 'simple) ; Set git mode to simple
            (setq treemacs-git-integration t) ; Enable git integration
            (setq treemacs-show-hidden-files t) ; Show hidden files
            (setq treemacs-icons-dired-mode t) ; Use icons in dired buffers
            (setq treemacs-set-scope-type 'Tabs)

            ; Enable column 80 line for coding
            (setq-default fill-column 80)
            (add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

            (setq org-directory "~/Sync/org-roam/")
            (setq org-roam-directory (file-truename "~/Sync/org-roam"))
            (org-roam-db-autosync-mode)
        '';
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
            set-option -g status-bg blue
            set-option -g pane-active-border-style fg=blue
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
