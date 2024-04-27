# Lenovo Thinkpad T440p with a Core i5 4210M, 16GB RAM, 512GB SSD.
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./home.nix
    ./disko.nix
  ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  #   initrd.postDeviceCommands = lib.mkAfter ''
  #     mkdir /btrfs_tmp
  #     mount /dev/sda2 /btrfs_tmp
  #     if [[ -e /btrfs_tmp/rootfs ]]; then
  #         mkdir -p /btrfs_tmp/old_roots
  #         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/rootfs)" "+%Y-%m-%-d_%H:%M:%S")
  #         mv /btrfs_tmp/rootfs "/btrfs_tmp/old_roots/$timestamp"
  #     fi

  #     delete_subvolume_recursively() {
  #         IFS=$'\n'
  #         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #             delete_subvolume_recursively "/btrfs_tmp/$i"
  #         done
  #         btrfs subvolume delete "$1"
  #     }

  #     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +5); do
  #         delete_subvolume_recursively "$i"
  #     done

  #     btrfs subvolume create /btrfs_tmp/rootfs
  #     umount /btrfs_tmp
  #   '';
  # };

  networking.hostName = "rustboro"; # Define your hostname.

  alyraffauf = {
    system = {
      plymouth.enable = true;
      zramSwap = {
        enable = true;
        size = 100;
      };
    };
    user = {
      aly = {
        enable = true;
        password = "$y$j9T$VdtiEyMOegHpcUwgmCVFD0$K8Ne6.zk//VJNq2zxVQ0xE0Wg3LohvAQd3Xm9aXdM15";
      };
      dustin.enable = false;
    };
    desktop = {
      enable = true;
      greetd = {
        enable = true;
        session = config.programs.sway.package + "/bin/sway";
      };
      sway.enable = true;
    };
    apps = {
      steam.enable = true;
    };
    services = {
      syncthing.enable = true;
    };
  };

  # environment.persistence."/persist" = {
  #   hideMounts = true;
  #   directories = [
  #     "/etc/NetworkManager/system-connections"
  #     "/etc/ssh"
  #   ];
  #   files = [
  #     "/etc/machine-id"
  #   ];
  # };

  system.stateVersion = "23.11"; # Did you read the comment?
}
