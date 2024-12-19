# Framework Laptop 13 with AMD Ryzen 7640U, 32GB RAM, 1TB SSD.
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
    self.nixosModules.hw-common-gaming
    self.nixosModules.hw-framework-13-amd-7000
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

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "lavaridge";

  services.udev.extraRules = let
    hyprlandDynamicRes = pkgs.writeShellScript "hyprland-dynamic-resolution" ''
      MON="eDP-1"
      RES="2880x1920"

      for dir in /run/user/*; do
        for hypr_dir in "$dir/hypr/"*/; do
          socket="''${hypr_dir}.socket.sock"
          if [[ -S $socket ]]; then
            monitor_info=$(echo -e "monitors" | ${lib.getExe pkgs.socat} - UNIX-CONNECT:"$socket")

            if echo "$monitor_info" | grep -q "$MON"; then
              echo -e "keyword monitor $MON, $RES@$1, 0x0, 2, vrr, $2" | ${lib.getExe pkgs.socat} - UNIX-CONNECT:"$socket"
            fi

          fi
        done
      done
    '';
  in ''
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="1", ACTION=="change", RUN+="${hyprlandDynamicRes} 120 1"
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_NAME}=="ACAD", ATTR{online}=="0", ACTION=="change", RUN+="${hyprlandDynamicRes} 60 0"
  '';

  system.stateVersion = "24.05";

  ar = {
    apps = {
      firefox.enable = true;
      podman.enable = true;
      steam.enable = true;
    };

    desktop = {
      greetd = {
        enable = true;
        session = lib.getExe' pkgs.kdePackages.plasma-workspace "startplasma-wayland";
      };

      kde.enable = true;
    };

    laptopMode = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncROMs = true;
      };
    };
  };
}
