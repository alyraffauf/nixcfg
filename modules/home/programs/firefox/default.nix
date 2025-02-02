{
  config,
  lib,
  ...
}: {
  options.myHome.programs.firefox.enable = lib.mkEnableOption "Firefox web browser.";

  config = lib.mkIf config.myHome.programs.firefox.enable {
    programs.firefox.enable = true;
  };
}
