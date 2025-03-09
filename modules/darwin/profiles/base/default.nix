{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myDarwin.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myDarwin.profiles.base.enable {
    environment = {
      systemPackages = with pkgs; [
        eza
        git
        rclone
      ];

      variables.FLAKE = lib.mkDefault "github:alyraffauf/nixcfg";
    };

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
  };
}
