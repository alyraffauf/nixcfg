{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.ssh.enable = lib.mkEnableOption "openssh client";

  config = lib.mkIf config.myHome.aly.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = let
        rootMe = name: {
          ${name} = {
            hostname = name;
            user = "root";
          };
        };
      in
        rootMe "dewford"
        // rootMe "evergrande"
        // rootMe "mossdeep"
        // rootMe "slateport"
        // {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        };

      package = pkgs.openssh;
    };
  };
}
