[
  {
    hostName = "lavaridge";
    maxJobs = 8;
    speedFactor = 3;
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
    hostName = "roxanne";
    maxJobs = 4;
    speedFactor = 1;
    sshUser = "aly";
    supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    system = "aarch64-linux";
  }
]
