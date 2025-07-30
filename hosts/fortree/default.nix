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

  environment = {
    shells = with pkgs; [
      fish
      zsh
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

    brews = [
      "mas"
      "podman"
      {
        name = "ollama";
        restart_service = "changed";
        start_service = true;
      }
    ];

    casks = let
      greedy = name: {
        inherit name;
        greedy = true;
      };
    in [
      (greedy "aws-vpn-client")
      (greedy "google-chrome")
      (greedy "obsidian")
      (greedy "plexamp")
      (greedy "signal")
      (greedy "slack")
      (greedy "thunderbird")
      (greedy "todoist-app")
      (greedy "vlc")
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Photomator" = 1444636541;
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
    };

    user = "aly";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  programs.fish.enable = true;

  security.sudo.extraConfig = ''
    root ALL=(ALL) NOPASSWD: ALL
    %admin ALL=(ALL) NOPASSWD: ALL
  '';

  system = {
    defaults = {
      dock.persistent-apps = [
        {app = "/System/Applications/Launchpad.app";}
        {app = "${self.inputs.zen-browser.packages.${pkgs.system}.beta}/Applications/Zen Browser (Beta).app";}
        {app = "/Applications/Signal.app";}
        {app = "${pkgs.vesktop}/Applications/Vesktop.app";}
        {app = "/Applications/Slack.app";}
        {app = "/Applications/Thunderbird.app";}
        {app = "/Applications/Obsidian.app";}
        {app = "${pkgs.zed-editor}/Applications/Zed.app";}
        {app = "${pkgs.ghostty-bin}/Applications/Ghostty.app";}
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
    profiles.base.enable = true;
    programs.nix.enable = true;
  };
}
