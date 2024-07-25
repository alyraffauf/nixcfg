# Lenovo Yoga 9i Convertible with Intel Core i7-1360P, 16GB RAM, 512GB SSD.
{
  config,
  self,
  ...
}: {
  imports = [
    ../common
    ./disko.nix
    ./home.nix
    ./secrets.nix
    self.inputs.nixhw.nixosModules.lenovo-yoga-9i-intel-13th
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.variables.GDK_SCALE = "2";
  networking.hostName = "petalburg";

  nixpkgs.overlays = [
    (final: prev: {
      brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};

      obsidian = prev.obsidian.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform=wayland"]
          ["--ozone-platform=wayland --enable-wayland-ime"]
          old.installPhase;
      });

      vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

      webcord = prev.webcord.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform-hint=auto"]
          ["--ozone-platform-hint=auto --enable-wayland-ime"]
          old.installPhase;
      });
    })
  ];

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
        autologin = "aly";
      };

      hyprland.enable = true;
      sway.enable = true;
    };

    users.aly = {
      enable = true;
      password = "$y$j9T$TitXX3J690cnK41XciNMg/$APKHM/os6FKd9H9aXGxaHaQ8zP5SenO9EO94VYafl43";
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
      };
    };
  };
}
