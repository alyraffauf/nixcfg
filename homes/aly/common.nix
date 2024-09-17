{
  pkgs,
  ...
}: {
  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      curl
    ];

    stateVersion = "24.05";
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

    gitui.enable = true;
    home-manager.enable = true;

    rbw = {
      enable = true;

      settings = {
        base_url = "https://passwords.raffauflabs.com";
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
      };
    };
  };

  systemd.user.startServices = "legacy"; # Needed for auto-mounting agenix secrets.

  ar.home = {
    apps = {
      fastfetch.enable = true;
      helix.enable = true;
      shell.enable = true;
      tmux.enable = true;
      yazi.enable = true;
    };
  };
}
