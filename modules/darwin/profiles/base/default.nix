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
      systemPackages = with pkgs; [nh];

      variables = {
        FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
        NH_FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
      };
    };

    networking.applicationFirewall.enable = true;

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
    system.configurationRevision = self.rev or self.dirtyRev or null;
  };
}
