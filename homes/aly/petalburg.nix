self: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./firefox
    ./mail
    ./secrets.nix
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
    self.inputs.stylix.homeManagerModules.stylix
  ];

  age.secrets = {
    syncthingCert.file = ../../secrets/aly/syncthing/petalburg/cert.age;
    syncthingKey.file = ../../secrets/aly/syncthing/petalburg/key.age;
  };

  home = {
    homeDirectory = "/var/home/aly";

    packages = with pkgs; [
      fractal
      gamescope
      heroic
      nicotine-plus
      obsidian
      tauon
      transmission-remote-gtk
      vesktop
    ];

    stateVersion = "25.05";
    username = "aly";
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";

      extraConfig = {
        color.ui = true;
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    home-manager.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-yxdrex.png";
    imageScalingMode = "fill";
    polarity = "dark";

    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };

    fonts = {
      monospace = {
        name = "CaskaydiaCove Nerd Font";
        package = pkgs.nerd-fonts.caskaydia-cove;
      };

      sansSerif = {
        name = "UbuntuSans Nerd Font";
        package = pkgs.nerd-fonts.ubuntu-sans;
      };

      serif = {
        name = "Source Serif Pro";
        package = pkgs.source-serif-pro;
      };

      sizes = {
        applications = 14;
        desktop = 12;
        popups = 12;
        terminal = 13;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };

    targets.gtk.enable = true;
  };

  services.syncthing = {
    enable = true;
    cert = config.age.secrets.syncthingCert.path;
    key = config.age.secrets.syncthingKey.path;

    settings = let
      devices = import ../../syncthing/devices.nix;

      folders = lib.mkMerge [
        (import ../../syncthing/folders.nix)
        {
          "music" = {
            enable = false;
            path = "~/music";
          };

          "roms".enable = true;
        }
      ];
    in {
      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = -1;
      };

      inherit devices folders;
    };
  };

  systemd.user = {
    services.syncthing.environment.STNODEFAULTFOLDER = "true";
    startServices = true; # Needed for auto-mounting agenix secrets.
  };

  targets.genericLinux.enable = true;

  xdg = {
    enable = true;
    mime.enable = true;

    systemDirs = {
      data = ["${config.home.homeDirectory}/.local/share/flatpak/exports/share"];
      config = ["/etc/xdg"];
    };
  };

  ar.home = {
    apps = {
      chromium.enable = true;
      shell.enable = true;
      vsCodium.enable = true;
    };

    desktop.kde.enable = true;

    services.easyeffects = {
      enable = true;
      preset = "AdvancedAutoGain";
    };
  };
}
