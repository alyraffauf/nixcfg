{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myDarwin.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myDarwin.profiles.base.enable {
    environment = {
      systemPackages = with pkgs; [
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

      ssh.knownHosts = import ../../../nixos/os/profiles/base/knownHosts.nix {inherit self;};
    };

    security.pam.services.sudo_local.touchIdAuth = true;
    services.openssh.enable = true;
  };
}
