{ pkgs, lib, config, ... }: {

  options = { cliApps.fzf.enable = lib.mkEnableOption "Enables fzf."; };

  config = lib.mkIf config.cliApps.fzf.enable {
    programs.fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };
  };
}
