{
  lib,
  pkgs,
  self,
  ...
}: let
  yoga-speakers = pkgs.writeShellApplication {
    # Compliments to the chef: https://github.com/maximmaxim345/yoga_pro_9i_gen9_linux/blob/b7f0fb294c010ba424fb577532091a5daa7fbae4/README.md
    name = "yoga-speakers";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
      gnused
      i2c-tools
      kmod
    ];
    text = ''
      export TERM=linux
      # Some distros don't have i2c-dev module loaded by default, so we load it manually
      modprobe i2c-dev
      # Function to find the correct I2C bus (third DesignWare adapter)
      find_i2c_bus() {
          adapter_description="Synopsys DesignWare I2C adapter"
          dw_count=$(i2cdetect -l | grep -c "$adapter_description")
          if [ "$dw_count" -lt 3 ]; then
              echo "Error: Less than 3 DesignWare I2C adapters found." >&2
              return 1
          fi
          bus_number=$(i2cdetect -l | grep "$adapter_description" | awk '{print $1}' | sed 's/i2c-//' | sed -n '3p')
          echo "$bus_number"
      }
      i2c_bus=$(find_i2c_bus)
      if [ -z "$i2c_bus" ]; then
          echo "Error: Could not find the third DesignWare I2C bus for the audio IC." >&2
          exit 1
      fi
      echo "Using I2C bus: $i2c_bus"
      i2c_addr=(0x3f 0x38)
      count=0
      for value in "''${i2c_addr[@]}"; do
          val=$((count % 2))
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x7f 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x01 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x0e 0xc4
          i2cset -f -y "$i2c_bus" "$value" 0x0f 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x5c 0xd9
          i2cset -f -y "$i2c_bus" "$value" 0x60 0x10
          if [ $val -eq 0 ]; then
              i2cset -f -y "$i2c_bus" "$value" 0x0a 0x1e
          else
              i2cset -f -y "$i2c_bus" "$value" 0x0a 0x2e
          fi
          i2cset -f -y "$i2c_bus" "$value" 0x0d 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x16 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x17 0xc8
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x04
          i2cset -f -y "$i2c_bus" "$value" 0x30 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x31 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x32 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x33 0x01
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x08
          i2cset -f -y "$i2c_bus" "$value" 0x18 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x19 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x1a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x1b 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x28 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x29 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x2a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x2b 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x0a
          i2cset -f -y "$i2c_bus" "$value" 0x48 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x49 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x4a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x4b 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x58 0x40
          i2cset -f -y "$i2c_bus" "$value" 0x59 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x5a 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x5b 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x00 0x00
          i2cset -f -y "$i2c_bus" "$value" 0x02 0x00
          count=$((count + 1))
      done
    '';
  };
  # yoga-speakers = pkgs.writeShellApplication {
  #   name = "yoga-reload-speakers";
  #   runtimeInputs = with pkgs; [
  #     kmod
  #   ];
  #   text = ''
  #     modprobe -r snd_hda_scodec_tas2781_i2c
  #     modprobe snd_hda_scodec_tas2781_i2c
  #   '';
  # };
in {
  imports = [
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-laptop
    self.nixosModules.hw-common-laptop-intel-cpu
    self.nixosModules.hw-common-nvidia-gpu
    self.nixosModules.hw-common-ssd
  ];

  boot = {
    extraModprobeConfig = ''
      # options snd_hda_intel power_save_controller=N
      # options snd_hda_intel power_save=0
      blacklist snd_hda_scodec_tas2781_i2c # Works initially, but then bass speakers stop working.
    '';

    initrd.availableKernelModules = ["thunderbolt" "nvme" "sdhci_pci"];
    kernelModules = ["i2c-dev"];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

    # kernelPatches = [
    #   {
    #     name = "hda-realtek-fixup-Lenovo-16IMH9";
    #     patch = ./0001-ALSA-hda-realtek-fixup-Lenovo-16IMH9.patch;
    #   }
    # ];
  };

  hardware = {
    i2c.enable = true;

    nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
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

  environment.systemPackages = [yoga-speakers];

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="i2c-dev", ATTR{name}=="Synopsys DesignWare I2C adapter", ATTR{power/async}="disabled"
  #   SUBSYSTEM=="i2c-dev", ATTR{name}=="Synopsys DesignWare I2C adapter", ATTR{power/control}="on"
  # '';

  specialisation.nvidia-sync.configuration = {
    environment.etc."specialisation".text = "nvidia-sync";

    hardware.nvidia = {
      powerManagement = {
        enable = lib.mkForce false;
        finegrained = lib.mkForce false;
      };

      prime = {
        offload = {
          enable = lib.mkForce false;
          enableOffloadCmd = lib.mkForce false;
        };

        sync.enable = lib.mkForce true;
      };
    };
  };

  systemd = {
    services.yoga-speakers = {
      enable = true;

      after = [
        "graphical.target"
        "sound.target"
      ];

      requires = ["sound.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe yoga-speakers}";
      };

      wantedBy = ["graphical.target"];
    };

    timers = {
      yoga-speakers = {
        enable = true;
        timerConfig.OnBootSec = "30s"; # Runs 30 seconds after boot
        wantedBy = ["timers.target"];
      };

      # yoga-speakers-resume = {
      #   enable = true;

      #   timerConfig = {
      #     OnStartupSec = "5s";
      #     Unit = "yoga-speakers.service";
      #   };

      #   wantedBy = [
      #     "hibernate.target"
      #     "hybrid-sleep.target"
      #     "suspend.target"
      #   ];
      # };
    };
  };
}
