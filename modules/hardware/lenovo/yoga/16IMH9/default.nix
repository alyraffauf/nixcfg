{
  lib,
  pkgs,
  self,
  ...
}: let
  turn-on-speakers = pkgs.writeShellApplication {
    name = "turn-on-speakers";

    runtimeInputs = with pkgs; [
      alsa-utils
      coreutils
      gawk
      gnugrep
      gnused
      i2c-tools
      kmod
    ];

    text = builtins.readFile ./turn-on-speakers.sh;
  };
in {
  imports = [
    self.nixosModules.hardware-common
    self.nixosModules.hardware-intel-cpu
    self.nixosModules.hardware-intel-gpu
    self.nixosModules.hardware-nvidia-gpu
    self.nixosModules.hardware-profiles-laptop
  ];

  boot = {
    extraModprobeConfig = ''
      # options snd_hda_intel power_save_controller=N
      # options snd_hda_intel power_save=0
      blacklist snd_hda_scodec_tas2781_i2c # Works initially, but then bass speakers stop working.
    '';

    initrd.availableKernelModules = ["thunderbolt" "nvme" "sdhci_pci"];
    kernelModules = ["i2c-dev"];
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.11") (lib.mkDefault pkgs.linuxPackages_latest);

    # This may be needed longterm, but for now tas2781 runtime power management is the main issue.
    # kernelPatches = [
    #   {
    #     name = "hda-realtek-fixup-Lenovo-16IMH9";
    #     patch = ./0001-ALSA-hda-realtek-fixup-Lenovo-16IMH9.patch;
    #   }
    # ];
  };

  hardware = {
    i2c.enable = true;
    sensor.iio.enable = true;

    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      videoAcceleration = false;
    };
  };

  home-manager = {
    sharedModules = [
      {
        services.easyeffects = {
          enable = true;
          preset = "16IMH9.json";
          # https://github.com/maximmaxim345/yoga_pro_9i_gen9_linux/blob/b7f0fb294c010ba424fb577532091a5daa7fbae4/Yoga%20Pro%209i%20gen%209%20v2.json
        };

        xdg.configFile."easyeffects/output/16IMH9.json".source = ./easyeffects.json;
      }
    ];
  };

  environment.systemPackages = [turn-on-speakers];
  nixpkgs.config.cudaSupport = true;

  systemd = {
    services.turn-on-speakers = {
      # Due to bugs in the snd_hda_scodec_tas2781_i2c module, the best way to have functional speakers is to run a small script to turn the bass speakers on via i2c.
      enable = true;

      after = [
        "graphical.target"
        "sound.target"
      ];

      requires = ["sound.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe turn-on-speakers}";
      };

      wantedBy = ["graphical.target"];
    };

    timers = {
      yoga-speakers = {
        enable = true;
        timerConfig.OnBootSec = "30s"; # Runs 30 seconds after boot
        wantedBy = ["timers.target"];
      };
    };
  };
}
