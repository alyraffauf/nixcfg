{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
  ];

  environment = {
    shells = with pkgs; [
      fish
    ];

    systemPackages = with pkgs; [
      (lib.hiPrio uutils-coreutils-noprefix)
      eza
      git
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-sans
    source-serif-pro
  ];

  homebrew = {
    enable = true;
    global.autoUpdate = false;
    greedyCasks = true;

    brews = [
      "mas"
      "podman"
      {
        name = "ollama";
        restart_service = "changed";
        start_service = true;
      }
    ];

    casks = [
      "aws-vpn-client"
      "brave-browser"
      "choosy"
      "firefox"
      "ghostty"
      "google-chrome"
      "obsidian"
      "plexamp"
      "signal"
      "slack"
      "thunderbird"
      "todoist-app"
      "vlc"
      "zed"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Photomator" = 1444636541;
    };

    onActivation = {
      # cleanup = "zap";
      upgrade = true;
    };

    # taps = builtins.attrNames config.nix-homebrew.taps;
  };

  networking = {
    computerName = "fortree";
    hostName = "fortree";
    localHostName = "fortree";
  };

  # nix-homebrew = {
  #   enable = true;
  #   mutableTaps = false;

  #   taps = {
  #     "homebrew/homebrew-core" = self.inputs.homebrew-core;
  #     "homebrew/homebrew-cask" = self.inputs.homebrew-cask;
  #   };

  #   user = "aly";
  # };

  nixpkgs.hostPlatform = "aarch64-darwin";
  programs.fish.enable = true;

  security.sudo.extraConfig = ''
    root ALL=(ALL) NOPASSWD: ALL
    %admin ALL=(ALL) NOPASSWD: ALL
  '';

  system = {
    defaults = {
      dock.persistent-apps = [
        {app = "/System/Applications/Apps.app";}
        {app = "/Applications/Firefox.app";}
        {app = "/Applications/Brave Browser.app";}
        {app = "/Applications/Google Chrome.app";}
        {app = "/Applications/Signal.app";}
        {app = "/Applications/Vesktop.app";}
        {app = "/Applications/Slack.app";}
        {app = "/Applications/Thunderbird.app";}
        {app = "/Applications/Obsidian.app";}
        {app = "/Applications/Zed.app";}
        {app = "/Applications/Ghostty.app";}
        {app = "/System/Applications/Music.app";}
        {app = "/Applications/Plexamp.app";}
        {app = "/System/Applications/iPhone Mirroring.app";}
      ];

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
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

    primaryUser = "aly";
    stateVersion = 6;
  };

  users.users = {
    aly = {
      description = "Aly Raffauf";
      home = "/Users/aly";

      openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: lib.hasPrefix "aly_" file)
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));

      shell = pkgs.fish;
    };

    root.openssh.authorizedKeys.keyFiles =
      lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
      (lib.filter (file: lib.hasPrefix "aly_" file)
        (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));
  };

  myDarwin = {
    base.enable = true;
    programs.nix.enable = true;
  };
}
