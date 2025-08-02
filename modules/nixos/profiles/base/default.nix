{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        (lib.hiPrio uutils-coreutils-noprefix)
        git
        helix
        htop
        lm_sensors
        wget
      ];

      variables = {
        FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
        NH_FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
      };
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      cachefilesd = {
        enable = true;

        extraConfig = ''
          brun 20%
          bcull 10%
          bstop 5%
        '';
      };

      vscode-server.enable = true;

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
    };

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      nixos.tags = ["base"];
      rebuild.enableNg = true;
    };
  };
}
