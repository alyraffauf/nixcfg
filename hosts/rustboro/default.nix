# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
    ./disko.nix
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # initrd.postDeviceCommands = lib.mkAfter ''
    #   mkdir /btrfs_tmp
    #   mount /dev/sda2 /btrfs_tmp
    #   if [[ -e /btrfs_tmp/rootfs ]]; then
    #       mkdir -p /btrfs_tmp/old_roots
    #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/rootfs)" "+%Y-%m-%-d_%H:%M:%S")
    #       mv /btrfs_tmp/rootfs "/btrfs_tmp/old_roots/$timestamp"
    #   fi

    #   delete_subvolume_recursively() {
    #       IFS=$'\n'
    #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #           delete_subvolume_recursively "/btrfs_tmp/$i"
    #       done
    #       btrfs subvolume delete "$1"
    #   }

    #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +10); do
    #       delete_subvolume_recursively "$i"
    #   done

    #   btrfs subvolume create /btrfs_tmp/rootfs
    #   umount /btrfs_tmp
    # '';
    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/sda2 /btrfs_tmp
      if [[ -e /btrfs_tmp/rootfs ]]; then
          btrfs subvolume delete /btrfs_tmp/rootfs
      fi

      btrfs subvolume create /btrfs_tmp/rootfs
      umount /btrfs_tmp
    '';
  };

  networking.hostName = "rustboro"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "ondemand";

  systemConfig = {
    plymouth.enable = true;
    zramSwap = {
      enable = true;
      size = 100;
    };
  };

  desktopConfig = {
    enable = true;
    windowManagers.hyprland.enable = true;
  };

  apps = {
    flatpak.enable = true;
    steam.enable = false;
  };

  users.users.aly.hashedPassword =
    "$y$j9T$VdtiEyMOegHpcUwgmCVFD0$K8Ne6.zk//VJNq2zxVQ0xE0Wg3LohvAQd3Xm9aXdM15";

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
