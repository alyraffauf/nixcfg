# Asus TUF A16 AMD Advantage Edition (2023) with AMD Ryzen 7 7735HS, 16GB RAM, RX7700S, 512GB SSD.
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/nvme0n1"];})
    self.nixosModules.common-auto-upgrade
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-asus-tuf-a16-amd-7030
    self.nixosModules.hw-common-gaming
  ];

  boot = {
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };
  };

  environment.variables.GDK_SCALE = "1.25";
  networking.hostName = "petalburg";

  services.udev.extraRules = let
    hyprlandDynamicRes = pkgs.writeShellScript "hyprland-dynamic-resolution" ''
      MON="desc:China Star Optoelectronics Technology Co. Ltd MNG007QA1-1"
      RES="1920x1200"

      for dir in /run/user/*; do
        for hypr_dir in "$dir/hypr/"*/; do
          socket="''${hypr_dir}.socket.sock"
          if [[ -S $socket ]]; then
            monitor_info=$(echo -e "monitors" | ${lib.getExe pkgs.socat} - UNIX-CONNECT:"$socket")

            if echo "$monitor_info" | grep -q "$MON"; then
              echo -e "keyword monitor $MON, $RES@$1, 0x0, 1.25, vrr, $2" | ${lib.getExe pkgs.socat} - UNIX-CONNECT:"$socket"
            fi

          fi
        done
      done
    '';
  in ''
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="1", ACTION=="change", RUN+="${hyprlandDynamicRes} 165 1"
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="0", ACTION=="change", RUN+="${hyprlandDynamicRes} 60 0"
  '';

  system.stateVersion = "24.11";

  ar = {
    apps = {
      firefox.enable = true;
      podman.enable = true;
      steam.enable = true;
      virt-manager.enable = true;
    };

    desktop = {
      greetd.enable = true;
      hyprland.enable = true;
      sway.enable = true;
    };

    laptopMode = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$lRa/vifTJrfAyKkVPklz8.$tSnmqnrJ1bkCncGH59Ug3U5c6CRyiUNH2hHEux0y/v8";
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncROMs = true;
      };
    };
  };
}
