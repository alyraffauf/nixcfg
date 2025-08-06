{
  config,
  lib,
  ...
}: {
  options.myHome.aly.programs.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.myHome.aly.programs.git.enable {
    programs = {
      git = {
        enable = true;
        delta.enable = true;
        lfs.enable = true;
        userName = "Aly Raffauf";
        userEmail = "aly@aly.codes";

        extraConfig = {
          color.ui = true;
          github.user = "alyraffauf";
          push.autoSetupRemote = true;
        };
      };

      gitui.enable = true;
    };
  };
}
