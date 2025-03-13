[
  {
    hostName = "lilycove";
    maxJobs = 6;
    speedFactor = 4;
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
]
