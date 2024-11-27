# Lenovo Legion Go
{
  config,
  pkgs,
  lib,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/nvme0n1"];})
    self.inputs.jovian.nixosModules.default
    self.inputs.nix-gaming.nixosModules.pipewireLowLatency
    self.inputs.nix-gaming.nixosModules.platformOptimizations
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-nix
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-lenovo-legion-go
  ];

  boot = {
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = lib.mkForce false;
        consoleMode = "1";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      heroic
      hhd-ui
      lutris
    ];

    variables.GDK_SCALE = "2";
  };

  hardware.pulseaudio.enable = lib.mkForce false;

  jovian = {
    decky-loader = {
      enable = true;
      user = "aly";
    };

    hardware.has.amd.gpu = true;

    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "plasma";

      environment = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = lib.makeSearchPathOutput "steamcompattool" "" config.programs.steam.extraCompatPackages;
        STEAM_GAMESCOPE_COLOR_MANAGED = "0";
      };

      user = "aly";
    };

    steamos = {
      enableMesaPatches = lib.mkForce false;
      useSteamOSConfig = true;
    };
  };

  networking.hostName = "pacifidlog";
  nixpkgs.overlays = [self.overlays.tablet];
  programs.steam.platformOptimizations.enable = true;

  services = {
    handheld-daemon = {
      enable = true;

      package = with pkgs;
        handheld-daemon.overrideAttrs (oldAttrs: {
          propagatedBuildInputs =
            oldAttrs.propagatedBuildInputs
            ++ [pkgs.adjustor];
        });

      user = "aly";
    };

    pipewire.lowLatency = {
      enable = true;
      quantum = 256;
      rate = 48000;
    };
  };

  system.stateVersion = "24.11";
  systemd.services.handheld-daemon.path = with pkgs; [hhd-ui lsof];
  zramSwap.memoryPercent = 100;

  ar = {
    apps = {
      firefox.enable = true;
      steam.enable = true;
    };

    desktop.kde.enable = true;
    laptopMode = true;
    services.flatpak.enable = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$CXjk5Z9e2PXbSsWh5CK.81$I9Hm/Oa4KcYMqPi8KMBfsEv5NzoXCgaCK5xhyGeikH7";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
      };
    };
  };
}
