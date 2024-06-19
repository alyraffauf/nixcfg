{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.bash.enable {
    programs.bash = {
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
      shellAliases = {
        cat = lib.getExe pkgs.bat;
      };
    };
  };
}
