{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./helix
    ./mail
    ./secrets.nix
    ./windowManagers
    self.homeManagerModules.profiles-defaultApps
    self.homeManagerModules.profiles-shell
    self.homeManagerModules.programs-fastfetch
    self.homeManagerModules.programs-vsCodium
    self.homeManagerModules.programs-yazi
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
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "enamippconapkdmgfgjchkhakpfinmaj";} # dearrow
        {id = "jldhpllghnbhlbpcmnajkpdmadaolakh";} # todoist
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic

        {
          id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-4.0.1.0.crx";
            sha256 = "sha256-n1vt+JKjXQnmA9Ytj2Tfu29yWgfc4EFnzaQ+X+CVqOw=";
          };

          version = "4.0.1.0";
        }
      ];

      package = pkgs.brave;
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
        base_url = "https://passwords.raffauflabs.com";
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };

    wezterm.enable = true;
  };

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.
}
