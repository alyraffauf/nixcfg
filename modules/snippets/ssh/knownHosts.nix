{
  lib,
  self,
  ...
}: {
  options.mySnippets.ssh.knownHosts = lib.mkOption {
    type = lib.types.attrs;
    description = "Default ssh known hosts.";

    default = {
      fallarbor = {
        hostNames = ["fallarbor" "fallarbor.local" "fallarbor.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_fallarbor.pub";
      };

      fortree = {
        hostNames = ["fortree" "fortree.local" "fortree.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_fortree.pub";
      };

      lavaridge = {
        hostNames = ["lavaridge" "lavaridge.local" "lavaridge.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_lavaridge.pub";
      };

      lilycove = {
        hostNames = ["lilycove" "lilycove.local" "lilycove.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_lilycove.pub";
      };

      mauville = {
        hostNames = ["mauville" "mauville.local" "mauville.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_mauville.pub";
      };

      mossdeep = {
        hostNames = ["mossdeep" "mossdeep.local" "mossdeep.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_mossdeep.pub";
      };

      petalburg = {
        hostNames = ["petalburg" "petalburg.local" "petalburg.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_petalburg.pub";
      };

      roxanne = {
        hostNames = ["roxanne" "roxanne.local" "roxanne.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_roxanne.pub";
      };

      rustboro = {
        hostNames = ["rustboro" "rustboro.local" "rustboro.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_rustboro.pub";
      };

      slateport = {
        hostNames = ["slateport" "slateport.local" "slateport.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_slateport.pub";
      };

      sootopolis = {
        hostNames = ["sootopolis" "sootopolis.local" "sootopolis.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_sootopolis.pub";
      };

      verdanturf = {
        hostNames = ["verdanturf" "verdanturf.local" "verdanturf.narwhal-snapper.ts.net"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_verdanturf.pub";
      };
    };
  };
}
