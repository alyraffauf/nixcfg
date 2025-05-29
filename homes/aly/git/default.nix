{...}: {
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
}
