{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myDarwin.profiles.base = {
    enable = lib.mkEnableOption "base system configuration";

    flakeUrl = lib.mkOption {
      type = lib.types.str;
      default = "github:alyraffauf/nixcfg";
      description = "Default flake URL for the system";
    };
  };

  config = lib.mkIf config.myDarwin.profiles.base.enable {
    environment = {
      etc."nix-darwin".source = self;
      systemPackages = with pkgs; [nh];

      variables = {
        FLAKE = config.myDarwin.profiles.base.flakeUrl;
        NH_FLAKE = config.myDarwin.profiles.base.flakeUrl;
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
