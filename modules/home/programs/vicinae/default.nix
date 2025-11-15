{
  config,
  lib,
  ...
}: {
  options.myHome.programs.vicinae.enable = lib.mkEnableOption "vicinae launcher";

  config = lib.mkIf config.myHome.programs.vicinae.enable {
    programs.vicinae = {
      enable = true;

      extensions = [
        (config.lib.vicinae.mkRayCastExtension {
          name = "gif-search";
          sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
          rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
        })
      ];

      systemd.enable = true;
    };
  };
}
