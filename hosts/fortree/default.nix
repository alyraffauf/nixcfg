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

  services.aerospace = {
    enable = false;

    settings = {
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers =
        false;

      gaps = {
        outer.left = 8;
        outer.bottom = 8;
        outer.top = 8;
        outer.right = 8;
        inner.horizontal = 8;
        inner.vertical = 8;
      };

      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];

      mode.main.binding = {
        alt-0 = "workspace 10";
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-h = "focus --boundaries-action wrap-around-the-workspace left";
        alt-j = "focus --boundaries-action wrap-around-the-workspace down";
        alt-k = "focus --boundaries-action wrap-around-the-workspace up";
        alt-l = "focus --boundaries-action wrap-around-the-workspace right";
        alt-leftSquareBracket = "split horizontal";
        alt-r = "mode resize";
        alt-rightSquareBracket = "split vertical";
        alt-shift-0 = ["move-node-to-workspace 10" "workspace 10"];
        alt-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
        alt-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
        alt-shift-3 = ["move-node-to-workspace 3" "workspace 3"];
        alt-shift-4 = ["move-node-to-workspace 4" "workspace 4"];
        alt-shift-5 = ["move-node-to-workspace 5" "workspace 5"];
        alt-shift-6 = ["move-node-to-workspace 6" "workspace 6"];
        alt-shift-7 = ["move-node-to-workspace 7" "workspace 7"];
        alt-shift-8 = ["move-node-to-workspace 8" "workspace 8"];
        alt-shift-9 = ["move-node-to-workspace 9" "workspace 9"];
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-shift-v = "layout floating tiling";
        alt-shift-w = "fullscreen";
        alt-v = "layout tiles";
      };

      mode.resize.binding = {
        alt-h = "resize width -50";
        alt-j = "resize height +50";
        alt-k = "resize height -50";
        alt-l = "resize width +50";
        enter = "mode main";
        esc = "mode main";
      };
    };
  };

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
