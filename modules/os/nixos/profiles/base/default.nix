{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    boot = {
      initrd.systemd.enable = lib.mkDefault true;

      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;

        systemd-boot = {
          enable = lib.mkDefault true;
          configurationLimit = lib.mkDefault 10;
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        curl
        git
        helix
        htop
        nodePackages.nodejs
        python3
        wget
      ];

      variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
    };

    networking = {
      networkmanager.enable = true;
      nftables.enable = true;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
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

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
    };
  };
}
