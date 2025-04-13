{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myDarwin.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myDarwin.profiles.base.enable {
    environment = {
      systemPackages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix)
        eza
        git
        rclone
      ];

      variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    security.pam.services.sudo_local.touchIdAuth = true;
    services.openssh.enable = true;

    system.defaults.alf = {
      globalstate = 1;
      loggingenabled = 1;
    };
  };
}
