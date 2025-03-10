{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./stylix.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-sans
    source-serif-pro
  ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
      "ollama"
    ];

    casks = [
      "firefox"
      "ghostty"
      "macfuse"
      "obsidian"
      "signal"
      "submariner"
      "thunderbird"
    ];

    masApps = {
      "Photomator – Photo Editor" = 1444636541;
    };

    onActivation = {
      cleanup = "uninstall"; # uninstall any not listed here
      upgrade = true; # not idempotent anymore
    };
  };

  networking = {
    computerName = "fortree";
    hostName = "fortree";
    localHostName = "fortree";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null; # Set Git commit hash for darwin-version.

    defaults = {
      dock = {
        autohide = false; # autohide dock
        mru-spaces = false; # do not rearrange spaces based on most recent use
        show-recents = false; # do not show recently closed apps

        # # set hot corners
        # wvous-tl-corner = 2;
        # wvous-tr-corner = 2;
        # wvous-bl-corner = 1;
        # wvous-br-corner = 1;

        # persistent-apps = [];
        # # persistent-others = ["~/Desktop" "~/Downloads"];
      };

      finder = {
        AppleShowAllFiles = true; # show hidden files
        CreateDesktop = false; # do not show icons on desktop
        FXDefaultSearchScope = "SCcf"; # search current folder by default
        NewWindowTarget = "Home";
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    stateVersion = 6;
  };

  users.users.aly = {
    description = "Aly Raffauf";
    home = "/Users/aly";

    openssh.authorizedKeys.keyFiles =
      lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
      (lib.filter (file: lib.hasPrefix "aly_" file)
        (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));

    shell = pkgs.zsh;
  };

  myDarwin = {
    profiles.base.enable = true;
    programs.nix.enable = true;
  };
}
