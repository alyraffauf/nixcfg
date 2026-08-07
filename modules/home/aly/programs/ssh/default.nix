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

      settings = let
        rootMe = name: {
          ${name} = {
            HostName = name;
            User = "root";
          };
        };
      in
        rootMe "snowpoint"
        // rootMe "celestic"
        // rootMe "solaceon"
        // {
          "*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            Compression = false;
            ServerAliveInterval = 0;
            ServerAliveCountMax = 3;
            HashKnownHosts = false;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ControlMaster = "no";
            ControlPath = "~/.ssh/master-%r@%n:%p";
            ControlPersist = "no";
          };
        };

      package = pkgs.openssh;
    };
  };
}
