{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myDarwin.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myDarwin.base.enable {
    environment = {
      etc."nix-darwin".source = self;
      systemPackages = with pkgs; [nh];

      variables = {
        inherit (config.myDarwin) FLAKE;
        NH_FLAKE = config.myDarwin.FLAKE;
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
