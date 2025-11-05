{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.myHome.aly.programs.git.enable {
    home.packages = [pkgs.wl-clipboard];

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
      };

      git = {
        enable = true;
        lfs.enable = true;

        settings = {
          color.ui = true;
          github.user = "alyraffauf";
          push.autoSetupRemote = true;

          user = {
            name = "Aly Raffauf";
            email = "aly@aly.codes";
          };
        };
      };

      lazygit.enable = true;
    };
  };
}
