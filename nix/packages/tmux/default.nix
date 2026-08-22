{
  inputs,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.tmux = inputs.nix-wrapper-modules.wrappers.tmux.wrap {
      inherit pkgs;

      sourceSensible = true;
      baseIndex = 1;
      historyLimit = 100000;
      modeKeys = "vi";
      mouse = true;
      statusKeys = "vi";
      terminal = "tmux-256color";

      plugins = with pkgs.tmuxPlugins; [
        yank
        resurrect
        prefix-highlight
        {
          plugin = tmux-fzf;
          configBefore = ''
            set-environment -g TMUX_FZF_LAUNCH_KEY 'f'
            set-environment -g TMUX_FZF_ORDER 'command|keybinding|session|window|pane'
            set-environment -g TMUX_FZF_OPTIONS '-p -w 70% -h 60% -m'
          '';
        }
        {
          plugin = tmux-sessionx;
          configBefore = ''
            set -g @sessionx-zoxide-mode 'on'
            set -g @sessionx-git-branch 'on'
          '';
        }
        {
          plugin = catppuccin;
          configBefore = ''
            set -g @catppuccin_flavor 'frappe'
            set -g @catppuccin_window_status_style 'basic'
            set -g @catppuccin_window_left_separator ' '
            set -g @catppuccin_window_middle_separator ' '
            set -g @catppuccin_window_right_separator ' '
            set -g @catppuccin_window_current_left_separator ' '
            set -g @catppuccin_window_current_middle_separator ' '
            set -g @catppuccin_window_current_right_separator ' '
          '';
        }
      ];

      prefixVar = [
        [
          "PATH"
          ":"
          (lib.makeBinPath (
            [
              pkgs.coreutils
              pkgs.fzf
              pkgs.git
              pkgs.gnugrep
              pkgs.gnused
              pkgs.ripgrep
              pkgs.zoxide
            ]
            ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [pkgs.upower]
          ))
        ]
      ];

      configAfter = ''
        bind -N "Select pane to the left of the active pane" h select-pane -L
        bind -N "Select pane below the active pane" j select-pane -D
        bind -N "Select pane above the active pane" k select-pane -U
        bind -N "Select pane to the right of the active pane" l select-pane -R

        bind -r -N "Resize the pane left by 5" H resize-pane -L 5
        bind -r -N "Resize the pane down by 5" J resize-pane -D 5
        bind -r -N "Resize the pane up by 5" K resize-pane -U 5
        bind -r -N "Resize the pane right by 5" L resize-pane -R 5

        set -g focus-events on
        set -as terminal-features ",xterm-256color:RGB,xterm-ghostty:RGB"
        set -g set-clipboard on
        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g automatic-rename on
        set -g automatic-rename-format '#{pane_current_command}'

        bind c new-window -c '#{pane_current_path}'
        bind '"' split-window -v -c '#{pane_current_path}'
        bind % split-window -h -c '#{pane_current_path}'
        bind -n M-Left previous-window
        bind -n M-Right next-window
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind -T copy-mode-vi Enter send-keys -X copy-selection-and-cancel
        bind r source-file "${placeholder "out"}/tmux.conf" \; display-message "tmux config reloaded"

        set -g status-position top
        set -g status-justify left
        set -g status-interval 5
        set -g status-style 'bg=colour235,fg=colour245'
        set -g status-left-length 30
        set -g status-left '#{prefix_highlight}#[fg=colour39,bold] #S #[default]'
        set -g status-right-length 80
        set -g status-right '#(git -C "#{pane_current_path}" branch --show-current 2>/dev/null | sed "s/^/ /")#(upower -i /org/freedesktop/UPower/devices/DisplayDevice 2>/dev/null | grep -q "state:" && upower -i /org/freedesktop/UPower/devices/DisplayDevice 2>/dev/null | rg --no-config --color=never -o "[0-9]+%" | head -1 | sed "s/^/  ⚡ /")#[fg=colour245]  %a %H:%M#[default]'
        set -g window-status-separator ' '
        setw -g monitor-activity on
        set -g visual-activity off
        set -g window-status-format '#[fg=colour245]#I:#{pane_current_command}#{?window_activity_flag,*,}#[default]'
        set -g window-status-current-format '#[bg=colour39,fg=colour235,bold] #I:#{pane_current_command} #[default]'
      '';
    };
  };
}
