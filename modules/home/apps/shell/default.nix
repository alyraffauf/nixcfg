{
  config,
  lib,
  ...
}: {
  options.myHome.apps.shell.enable = lib.mkEnableOption "Shell with defaults.";

  config = lib.mkIf config.myHome.apps.shell.enable {
    home.shellAliases = {
      cat = "bat";
      grep = "rg";
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

        initExtra = ''
          export PS1="[\[$(tput setaf 27)\]\u\[$(tput setaf 135)\]@\[$(tput setaf 45)\]\h:\[$(tput setaf 33)\]\w] \[$(tput sgr0)\]$ "
        '';
      };

      bat.enable = true;
      direnv.enable = true;

      eza = {
        enable = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = "auto";
      };

      fzf.enable = true;

      oh-my-posh = {
        enable = true;
        useTheme = "zash";
      };

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      zellij.enable = true;

      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
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
