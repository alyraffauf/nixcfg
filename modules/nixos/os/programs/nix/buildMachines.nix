[
  {
    hostName = "lilycove";
    maxJobs = 6;
    speedFactor = 4;
    sshKey = "/home/aly/.ssh/id_ed25519";
    sshUser = "root";
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    system = "x86_64-linux";
  }
  {
    hostName = "mauville";
    maxJobs = 4;
    speedFactor = 1;
    sshKey = "/home/aly/.ssh/id_ed25519";
    sshUser = "root";
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    system = "x86_64-linux";
  }

  {
    hostName = "roxanne";
    maxJobs = 4;
    speedFactor = 1;
    sshKey = "/home/aly/.ssh/id_ed25519";
    sshUser = "root";
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    system = "aarch64-linux";
  }
]
