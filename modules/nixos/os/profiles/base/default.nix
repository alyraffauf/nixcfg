{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    environment = {
      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        (lib.hiPrio uutils-coreutils-noprefix)
        git
        helix
        htop
        wget
      ];

      variables = {
        FLAKE = lib.mkDefault "git+https://git.aly.codes/alyraffauf/nixcfg.git";
        NH_FLAKE = lib.mkDefault "git+https://git.aly.codes/alyraffauf/nixcfg.git";
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
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;

        publish = {
          enable = true;
          addresses = true;
          userServices = true;
          workstation = true;
        };
      };

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

    system.rebuild.enableNg = true;
  };
}
