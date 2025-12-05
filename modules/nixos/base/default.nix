{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.base = {
    enable = lib.mkEnableOption "base system configuration";
  };

  config = lib.mkIf config.myNixOS.base.enable {
    console.useXkbConfig = true;

    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        headsetcontrol
        helix
        lm_sensors
        wget
      ];

      variables = {
        inherit (config.myNixOS) FLAKE;
        NH_FLAKE = config.myNixOS.FLAKE;
      };
    };

    hardware = {
      keyboard.qmk.enable = true;
      logitech.wireless.enable = true;
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      git.enable = true;
      htop.enable = true;
      nh.enable = true;
      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      fwupd.enable = true;

      logind.settings.Login = {
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
      };

      udev.packages = [pkgs.headsetcontrol];
      usbmuxd.enable = true;

      xserver.xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    system.configurationRevision = self.rev or self.dirtyRev or null;

    myNixOS = {
      profiles = {
        bluetooth.enable = true;
        performance.enable = true;
        swap.enable = true;
      };

      programs = {
        njust.enable = true;
        uutils.enable = true;
      };

      services.openssh.enable = true;
    };
  };
}
