{
  config,
  lib,
  ...
}: {
  options.myHome.programs.vicinae.enable = lib.mkEnableOption "vicinae launcher";

  config = lib.mkIf config.myHome.programs.vicinae.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
    };
  };
}
