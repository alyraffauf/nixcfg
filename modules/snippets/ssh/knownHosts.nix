{
  config,
  lib,
  self,
  ...
}: {
  options.mySnippets.ssh.knownHosts = lib.mkOption {
    type = lib.types.attrs;
    description = "Default ssh known hosts.";

    default = {
      fallarbor = {
        hostNames = ["fallarbor" "fallarbor.local" "fallarbor.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_fallarbor.pub";
      };

      fortree = {
        hostNames = ["fortree" "fortree.local" "fortree.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_fortree.pub";
      };

      lavaridge = {
        hostNames = ["lavaridge" "lavaridge.local" "lavaridge.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_lavaridge.pub";
      };

      lilycove = {
        hostNames = ["lilycove" "lilycove.local" "lilycove.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_lilycove.pub";
      };

      mauville = {
        hostNames = ["mauville" "mauville.local" "mauville.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_mauville.pub";
      };

      mossdeep = {
        hostNames = ["mossdeep" "mossdeep.local" "mossdeep.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_mossdeep.pub";
      };

      petalburg = {
        hostNames = ["petalburg" "petalburg.local" "petalburg.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_petalburg.pub";
      };

      rustboro = {
        hostNames = ["rustboro" "rustboro.local" "rustboro.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_rustboro.pub";
      };

      slateport = {
        hostNames = ["slateport" "slateport.local" "slateport.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_slateport.pub";
      };

      sootopolis = {
        hostNames = ["sootopolis" "sootopolis.local" "sootopolis.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_sootopolis.pub";
      };

      verdanturf = {
        hostNames = ["verdanturf" "verdanturf.local" "verdanturf.${config.mySnippets.tailnet}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_verdanturf.pub";
      };
    };
  };
}
