{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.ar.home.apps.backblaze;
in {
  config = lib.mkIf cfg.enable {
    home = {
      activation.backblazeAuthentication = lib.hm.dag.entryAfter ["reloadSystemd"] ''
        ${
          if ((cfg.keyIdFile != null) && (cfg.keyFile != null))
          then ''
            XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
            run --quiet ${lib.getExe pkgs.backblaze-b2} authorize_account `${lib.getExe' pkgs.coreutils "cat"} ${cfg.keyIdFile}` `${lib.getExe' pkgs.coreutils "cat"} ${cfg.keyFile}`''
          else ''run echo "backblaze: Missing keyIDfile and keyFile."''
        }
      '';

      packages = with pkgs; [backblaze-b2];
    };
  };
}
