{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ar.home.apps.backblaze;
in {
  config = lib.mkIf cfg.enable {
    home = {
      activation.backblazeAuthentication = lib.hm.dag.entryAfter ["writeBoundary" "reloadSystemD"] ''
        ${
          if ((cfg.keyIdFile != null) && (cfg.keyFile != null))
          then "run --quiet ${lib.getExe pkgs.backblaze-b2} authorize_account `${lib.getExe' pkgs.coreutils "cat"} ${cfg.keyIdFile}` `${lib.getExe' pkgs.coreutils "cat"} ${cfg.keyFile}`"
          else ''run echo "backblaze: Missing keyIDfile and keyFile."''
        }
      '';

      packages = with pkgs; [backblaze-b2];
    };
  };
}
