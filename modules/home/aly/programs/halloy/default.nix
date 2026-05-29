{
  config,
  lib,
  ...
}: {
  options.myHome.aly.programs.halloy.enable = lib.mkEnableOption "halloy";

  config = lib.mkIf config.myHome.aly.programs.halloy.enable {
    sops.secrets.halloy = {
      sopsFile = ../../../../../secrets/halloy.yaml;
      key = "config";
      path = "${config.xdg.configHome}/halloy/config.toml";
    };

    programs.halloy = {
      enable = true;
      settings = lib.mkForce {};
    };
  };
}
