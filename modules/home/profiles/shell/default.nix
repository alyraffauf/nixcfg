{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.profiles.shell.enable = lib.mkEnableOption "basic shell environment";

  config = lib.mkIf config.myHome.profiles.shell.enable {
    home = {
      packages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix)
      ];

      shellAliases = {
        cat = "bat";
        grep = "rg";
      };
    };

    programs = {
      bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;

        shellOptions = [
          "autocd"
          "cdspell"
          "checkjobs"
          "checkwinsize"
          "dirspell"
          "dotglob"
          "extglob"
          "globstar"
          "histappend"
        ];
      };

      bat.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      eza = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = "auto";
      };

      fzf.enable = true;
      htop.enable = true;

      oh-my-posh = {
        enable = true;
        useTheme = "xtoys";
      };

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      yazi = {
        enable = true;
        enableBashIntegration = true;

        settings = {
          log.enabled = false;

          manager = {
            show_hidden = false;
            sort_by = "mtime";
            sort_dir_first = true;
            sort_reverse = true;
            sort_sensitive = true;
            linemode = "size";
            show_symlink = true;
          };

          preview.tab_size = 4;
        };
      };

      zellij = {
        enable = true;
        enableBashIntegration = false;
        enableZshIntegration = false;
        enableFishIntegration = false;
      };

      zoxide = {
        enable = true;
        options = ["--cmd cd"];
      };

      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        enableVteIntegration = true;

        initContent = ''
          [[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

          if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
            export TERM=xterm-256color
          fi
        '';

        historySubstringSearch.enable = true;

        history = {
          expireDuplicatesFirst = true;
          extended = true;
          ignoreAllDups = true;
        };
      };
    };
  };
}
