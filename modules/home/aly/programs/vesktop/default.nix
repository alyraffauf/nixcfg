{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.vesktop.enable = lib.mkEnableOption "vesktop";

  config = lib.mkIf config.myHome.aly.programs.vesktop.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        appBadge = false;
        arRPC = true;

        customTitleBar =
          if pkgs.stdenv.isLinux
          then true
          else false;

        disableMinSize = true;
        enableSplashScreen = false;

        minimizeToTray =
          if pkgs.stdenv.isLinux
          then true
          else false;

        tray = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };

      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = false;
        disableMinSize = true;
        notifyAboutUpdates = false;

        plugins = {
          AlwaysTrust.enabled = true;
          BlurNSFW.enabled = true;
          ClearURLs.enabled = true;
          FakeNitro.enabled = true;
          PinDMs.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
        };

        useQuickCss = true;
      };
    };
  };
}
