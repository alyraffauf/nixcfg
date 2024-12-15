self: {
  config,
  pkgs,
  ...
}: {
  home = {
    homeDirectory = "/var/home/aly";

    packages = with pkgs; [
      fractal
      vesktop
    ];

    stateVersion = "25.05";
    username = "aly";
  };

  programs.home-manager.enable = true;

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

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.
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
