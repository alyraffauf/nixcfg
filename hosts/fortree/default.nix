{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./home.nix
    self.inputs.home-manager.darwinModules.default
  ];

  environment.systemPackages = with pkgs; [
    eza
    git
    rclone
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-sans
    source-serif-pro
  ];

  homebrew = {
    enable = true;

    casks = [
      "firefox"
      "ghostty"
      "macfuse"
      "obsidian"
      "signal"
      "submariner"
      "thunderbird"
    ];

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

  nix = {
    buildMachines = let
      sshUser = "root";
      sshKey = "/Users/aly/.ssh/id_ed25519";
    in
      lib.filter (m: m.hostName != "${config.networking.hostName}") [
        {
          inherit sshUser sshKey;
          hostName = "lilycove";
          maxJobs = 6;
          speedFactor = 4;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }

        {
          inherit sshUser sshKey;
          hostName = "mauville";
          maxJobs = 4;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }

        {
          inherit sshUser sshKey;
          hostName = "slateport";
          maxJobs = 4;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }

        {
          inherit sshUser sshKey;
          hostName = "roxanne";
          maxJobs = 4;
          speedFactor = 1;
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "aarch64-linux";
        }
      ];

    distributedBuilds = true;

    gc = {
      automatic = true;

      interval = [
        {
          Hour = 9;
        }
      ];
    };

    linux-builder = {
      enable = true;
      ephemeral = true;

      config.virtualisation = {
        cores = 6;

        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
      };

      maxJobs = 4;
    };

    settings = {
      builders-use-substitutes = true;
      experimental-features = "nix-command flakes";
      trusted-users = ["@admin"];
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    ssh.knownHosts = {
      fallarbor = {
        hostNames = ["fallarbor" "fallarbor.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_fallarbor.pub";
      };

      lilycove = {
        hostNames = ["lilycove" "lilycove.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_lilycove.pub";
      };

      mauville = {
        hostNames = ["mauville" "mauville.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_mauville.pub";
      };

      petalburg = {
        hostNames = ["petalburg" "petalburg.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_petalburg.pub";
      };

      roxanne = {
        hostNames = ["roxanne" "roxanne.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_roxanne.pub";
      };

      slateport = {
        hostNames = ["slateport" "slateport.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_slateport.pub";
      };

      sootopolis = {
        hostNames = ["sootopolis" "sootopolis.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_sootopolis.pub";
      };

      verdanturf = {
        hostNames = ["verdanturf" "verdanturf.local"];
        publicKey = builtins.readFile "${self.inputs.secrets}/publicKeys/root_verdanturf.pub";
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  services.openssh.enable = true;

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
}
