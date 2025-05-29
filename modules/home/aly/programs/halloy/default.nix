{
  config,
  lib,
  self,
  ...
}: {
  options.myHome.aly.programs.halloy.enable = lib.mkEnableOption "halloy";

  config = lib.mkIf config.myHome.aly.programs.halloy.enable {
    age.secrets.halloy = {
      file = "${self.inputs.secrets}/aly/halloy.age";
      path = "${config.xdg.configHome}/halloy/config.toml";
    };

    programs.halloy = {
      enable = true;
      settings = lib.mkForce {};
    };
  };
}
