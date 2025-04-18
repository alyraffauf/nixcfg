{lib, ...}: {
  options = {
    mySnippets.nix.buildMachines = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "List of default nix build machines.";

      default = [
        {
          hostName = "lavaridge";
          maxJobs = 8;
          speedFactor = 4;
          sshUser = "aly";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }
        {
          hostName = "lilycove";
          maxJobs = 12;
          speedFactor = 4;
          sshUser = "aly";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }
        {
          hostName = "mauville";
          maxJobs = 4;
          speedFactor = 1;
          sshUser = "aly";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }
        {
          hostName = "roxanne";
          maxJobs = 4;
          speedFactor = 1;
          sshUser = "aly";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "aarch64-linux";
        }
        {
          hostName = "slateport";
          maxJobs = 4;
          speedFactor = 1;
          sshUser = "aly";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          system = "x86_64-linux";
        }
      ];
    };
  };
}
