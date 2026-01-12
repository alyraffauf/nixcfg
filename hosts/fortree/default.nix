{
  lib,
  pkgs,
  self,
  ...
}: {
  # imports = [
  #   ./home.nix
  # ];

  environment = {
    shells = with pkgs; [
      fish
    ];

    # systemPackages = with pkgs; [
    #   (lib.hiPrio uutils-coreutils-noprefix)
    #   git
    # ];
  };

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

    # masApps = {
    #   "Bitwarden" = 1352778147;
    #   "Photomator" = 1444636541;
    # };

    onActivation = {
      # cleanup = "zap";
      upgrade = true;
    };
  };

  networking = {
    computerName = "fortree";
    hostName = "fortree";
    localHostName = "fortree";
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  programs.fish.enable = true;

  security.sudo.extraConfig = ''
    root ALL=(ALL) NOPASSWD: ALL
    %admin ALL=(ALL) NOPASSWD: ALL
  '';

  system = {
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
