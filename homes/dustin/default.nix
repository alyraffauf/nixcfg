{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.fontix.homeModules.default
    self.inputs.safari.homeModules.default
  ];

  home = {
    username = "dustin";
    homeDirectory = "/home/dustin";
    stateVersion = "25.11";

    packages = with pkgs; [
      fractal
      plexamp
      signal-desktop-bin
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
    vesktop.enable = true;

    zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.bitwarden-desktop];
    };
  };

  wayland.windowManager = {
    hyprland.settings = {
      bind = ["SUPER,P,exec,${lib.getExe pkgs.rofi-rbw-wayland}"];
    };
  };

  fontix = {
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
    };

    sizes = {
      applications = 12;
      desktop = 11;
    };

    font-packages.enable = true;
    fontconfig.enable = true;
  };

  safari.enable = true;
  myHome.profiles.defaultApps.enable = true;
}
