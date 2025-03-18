{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-sans
    source-serif-pro
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = false;

    brews = [
      "mas"
      "ollama"
    ];

    casks = [
      "firefox"
      "ghostty"
      "google-chrome"
      "macfuse"
      "obsidian"
      "plexamp"
      "signal"
      "slack"
      "thunderbird"
      "todoist"
    ];

    masApps = {
      "Photomator – Photo Editor" = 1444636541;
    };

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  networking = {
    computerName = "fortree";
    hostName = "fortree";
    localHostName = "fortree";
  };

  nix-homebrew = {
    enable = true;
    mutableTaps = false;

    taps = {
      "homebrew/homebrew-core" = self.inputs.homebrew-core;
      "homebrew/homebrew-cask" = self.inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = self.inputs.homebrew-bundle;
    };

    user = "aly";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null; # Set Git commit hash for darwin-version.

    defaults = {
      dock = {
        autohide = true; # autohide dock
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

      userKeyMapping = [
        {
          HIDKeyboardModifierMappingSrc = 30064771129;
          HIDKeyboardModifierMappingDst = 30064771299;
        }
      ];
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
