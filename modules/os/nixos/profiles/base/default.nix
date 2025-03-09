{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    environment = {
      systemPackages = with pkgs; [
        (inxi.override {withRecommends = true;})
        git
        helix
        htop
        wget
      ];

      variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;

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

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;

        publish = {
          enable = true;
          addresses = true;
          userServices = true;
          workstation = true;
        };
      };

      vscode-server.enable = true;

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
    };
  };
}
