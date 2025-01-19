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
    self.nixosModules.common-mauville-share
    self.nixosModules.common-wifi-profiles
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hw-framework-13-amd-7000
    self.nixosModules.locale-en-us
    self.nixosModules.nixos-desktop-hyprland
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-desktopOptimizations
    self.nixosModules.nixos-profiles-gaming
    self.nixosModules.nixos-programs-firefox
    self.nixosModules.nixos-programs-lanzaboote
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-podman
    self.nixosModules.nixos-programs-steam
    self.nixosModules.nixos-services-greetd
    self.nixosModules.nixos-services-syncthing
    self.nixosModules.nixos-services-tailscale
  ];

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "lavaridge";

  services = {
    pipewire.lowLatency = true;

    udev.extraRules = lib.mkIf config.programs.hyprland.enable (let
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
    '');
  };

  system.stateVersion = "24.05";

  myNixOS.syncthing = {
    enable = true;
    certFile = config.age.secrets.syncthingCert.path;
    keyFile = config.age.secrets.syncthingKey.path;
    syncMusic = true;
    syncROMs = true;
    user = "aly";
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
  };
}
