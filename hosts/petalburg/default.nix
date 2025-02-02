# Lenovo Yoga Pro 9i with Intel Meteor Lake Core Ultra 9 + NVIDIA 4050 GPU, 32GB RAM, 1TB SSD, and a 16" display.
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
    self.nixosModules.disko-luks-btrfs-subvolumes
    self.nixosModules.hardware-lenovo-yoga-16IMH9
    self.nixosModules.locale-en-us
  ];

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "petalburg";

  specialisation.jarvis.configuration = {
    services.ollama = {
      enable = true;

      loadModels = [
        "deepseek-r1:14b"
        "llama3.1:8b"
      ];
    };
  };

  services = {
    pipewire.lowLatency.enable = false;

    udev.extraRules = lib.mkIf config.programs.hyprland.enable (let
      hyprlandDynamicRes = pkgs.writeShellScript "hyprland-dynamic-resolution" ''
        MON="eDP-1"
        RES="3200x2000"

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
      ## Dynamic refresh rate for Hyprland
      ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", RUN+="${hyprlandDynamicRes} 60 0"
      ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", RUN+="${hyprlandDynamicRes} 165 1"
    '');

    xserver.xkb.options = "ctrl:nocaps";
  };

  system.stateVersion = "25.05";
  time.timeZone = "America/New_York";

  myNixOS = {
    desktop.hyprland = {
      enable = true;
      laptopMonitor = "desc:Lenovo Group Limited 0x8BA1 0x00006003,3200x2000@60, 0x0, 2, vrr, 0";
    };

    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      desktop.enable = true;
      gaming.enable = true;
      media-share.enable = true;
      wifi.enable = true;
    };

    programs = {
      firefox.enable = true;
      nix.enable = true;
      steam.enable = true;
      lanzaboote.enable = true;
    };

    services = {
      greetd.enable = true;

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = true;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$NSS7QcEtN4yiigPyofwlI/$nxdgz0lpySa0heDMjGlHe1gX3BWf48jK6Tkfg4xMEs6";
  };
}
