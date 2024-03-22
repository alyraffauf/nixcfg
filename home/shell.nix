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
        package = pkgs.emacs-nox;
        extraConfig = ''
            (setq-default indent-tabs-mode nil)
            (setq-default tab-width 4)
            (setq indent-line-function 'insert-tab)
            (xterm-mouse-mode 1)
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
        terminal = "tmux-256color";
        extraConfig = ''
            set-option -g status-bg blue
            set-option -g pane-active-border-style fg=blue
        '';
    };
}