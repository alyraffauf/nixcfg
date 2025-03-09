{self, ...}: {
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
}
