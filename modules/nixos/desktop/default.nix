{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cosmic
    ./gnome
    ./hyprland
    ./kde
  ];

  options.myNixOS.desktop.enable = lib.mkOption {
    default = config.myNixOS.desktop.gnome.enable or config.myNixOS.desktop.hyprland.enable or config.myNixOS.desktop.kde.enable;
    description = "Desktop environment configuration.";
    type = lib.types.bool;
  };

  config = lib.mkIf config.myNixOS.desktop.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];

      loader.timeout = 0;
      plymouth.enable = true;
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [gearlever];
    };

    home-manager.sharedModules = [
      {
        config.myHome.desktop.enable = true;
      }
    ];

    programs = {
      appimage = {
        enable = true;
        binfmt = true;
      };

      system-config-printer.enable = true;
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

      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, etc.
      libinput.enable = true;

      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };

      printing.enable = true;

      pulseaudio = {
        package = pkgs.pulseaudioFull; # Use extra Bluetooth codecs like aptX

        extraConfig = ''
          load-module module-bluetooth-discover
          load-module module-bluetooth-policy
          load-module module-switch-on-connect
        '';

        support32Bit = true;
      };

      system-config-printer.enable = true;

      xserver = {
        enable = true;
        excludePackages = with pkgs; [xterm];
      };
    };
  };
}
