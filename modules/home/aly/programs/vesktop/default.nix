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

      settings = lib.mkMerge [
        {
          appBadge = false;
          arRPC = true;
          disableMinSize = true;
          enableSplashScreen = false;
          tray = true;
          hardwareAcceleration = true;
          discordBranch = "stable";
        }

        (lib.mkIf pkgs.stdenv.isLinux {
          autoStartMinimized = true;
          customTitleBar = true;
          minimizeToTray = true;
        })
      ];

      vencord = {
        settings = {
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

        useSystem = true;
      };
    };
  };
}
