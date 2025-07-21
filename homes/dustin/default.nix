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
      package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);
    };
  };

  stylix.targets.firefox.profileNames = ["default"];

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
}
