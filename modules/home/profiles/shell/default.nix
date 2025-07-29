{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myHome.profiles.shell.enable = lib.mkEnableOption "basic shell environment";

  config = lib.mkIf config.myHome.profiles.shell.enable {
    home = {
      packages = with pkgs;
        [
          (lib.hiPrio uutils-coreutils-noprefix)
          curl
          htop
          nixos-rebuild
          wget
        ]
        ++ [self.inputs.nynx.packages.${pkgs.system}.nynx];

      shellAliases = {
        l = "eza -lah";
        tree = "eza --tree";
        top = "htop";
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

        stdlib = ''
          : ''${XDG_CACHE_HOME:=$HOME/.cache}
          declare -A direnv_layout_dirs

          direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
            )}"
          }
        '';
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

      ripgrep-all.enable = true;
      joshuto.enable = true;

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
