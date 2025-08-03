{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.default
  ];

  home = {
    username = "dustin";
    homeDirectory = "/home/dustin";
    stateVersion = "24.05";

    packages = with pkgs; [
      calibre
      fractal
      libreoffice-still
      marp-cli
      plexamp
      signal-desktop-bin
      stellarium
      teams-for-linux
      trayscale
      webcord
      zoom-us
    ];
  };

  programs = {
    chromium = {
      enable = true;

      extensions = [
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
      ];

      package = pkgs.brave;
    };

    firefox.enable = true;
    home-manager.enable = true;

    rbw = {
      enable = true;

      settings = {
        email = "dustinmraffauf@gmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };

    zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.bitwarden];
    };
  };

  wayland.windowManager = {
    hyprland.settings = {
      bind = ["SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications."application/epub+zip" = "com.calibre_ebook.calibre.desktop;org.gnome.Evince.desktop;com.calibre_ebook.calibre.ebook-viewer.desktop;";
  };

  myHome = {
    profiles = {
      defaultApps.enable = true;
      shell.enable = true;
    };

    programs.fastfetch.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
    image = "${self.inputs.wallpapers}/wallhaven-yxdrex.png";
    imageScalingMode = "fill";
    polarity = "dark";

    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
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
        applications = 12;
        desktop = 11;
        popups = 12;
        terminal = 12;
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };
  };
}
