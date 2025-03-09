{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./cloud
    ./firefox
    ./git
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    ./windowManagers
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
  ];

  gtk.gtk3.bookmarks = lib.mkAfter [
    "file://${config.home.homeDirectory}/sync"
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      curl
      fractal
      nicotine-plus
      obsidian
      protonvpn-gui
      rclone
      signal-desktop
      tauon
      transmission-remote-gtk
      vesktop
    ];

    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    chromium = {
      enable = true;

      extensions = [
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector

        rec {
          id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean
          version = "4.0.4.0";

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${version}.crx";
            sha256 = "sha256-bEjC58vCExU7vlXn1h0yn14jIrBUo/HtFuDlXa0DzC0=";
          };
        }
      ];

      package = pkgs.chromium;
    };

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

    gitui.enable = true;
    home-manager.enable = true;

    rbw = {
      enable = true;

      settings = {
        base_url = "https://vault.cute.haus";
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };

    wezterm.enable = true;
  };

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

  myHome = {
    profiles = {
      defaultApps = {
        enable = true;
        editor.package = config.programs.vscode.package;
      };

      shell.enable = true;
    };

    programs.fastfetch.enable = true;
  };
}
