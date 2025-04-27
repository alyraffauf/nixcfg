{lib, ...}: {
  options = {
    mySnippets.nix.buildMachines = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "List of default nix build machines.";

      default = [
        {
          hostName = "lavaridge";
          maxJobs = 8;
          speedFactor = 3;
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          sshUser = "nixbuild";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["x86_64-linux"];
        }
        {
          hostName = "lilycove";
          maxJobs = 12;
          speedFactor = 5;
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          sshUser = "nixbuild";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["x86_64-linux"];
        }
        {
          hostName = "mauville";
          maxJobs = 4;
          speedFactor = 2;
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          sshUser = "nixbuild";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["x86_64-linux"];
        }
        {
          hostName = "roxanne";
          maxJobs = 4;
          speedFactor = 1;
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          sshUser = "nixbuild";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["aarch64-linux"];
        }
        {
          hostName = "slateport";
          maxJobs = 4;
          speedFactor = 2;
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          sshUser = "nixbuild";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["x86_64-linux"];
        }
      ];
    };
  };
}
