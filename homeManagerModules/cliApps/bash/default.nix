{ pkgs, lib, config, ... }: {

  options = { cliApps.bash.enable = lib.mkEnableOption "Enables bash."; };

  config = lib.mkIf config.cliApps.bash.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        export PS1="[\[$(tput setaf 27)\]\u\[$(tput setaf 135)\]@\[$(tput setaf 45)\]\h:\[$(tput setaf 33)\]\w] \[$(tput sgr0)\]$ "
      '';
    };
  };
}
