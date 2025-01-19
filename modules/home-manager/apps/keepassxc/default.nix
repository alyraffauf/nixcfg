{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.myHome.apps.keepassxc.enable {
    home.packages = [config.myHome.apps.keepassxc.package];

    xdg.configFile."keepassxc/keepassxc.ini".text = let
      defaults = {
        Browser = {
          AlwaysAllowAccess = true;
          Enabled = true;
          SearchInAllDatabases = true;
          UpdateBinaryPath = false;
        };

        General = {
          ConfigVersion = 2;
          HideWindowOnCopy = true;
          MinimizeAfterUnlock = false;
          MinimizeOnOpenUrl = true;
        };

        GUI = {
          ApplicationTheme = "classic";
          ColorPasswords = false;
          CompactMode = true;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "colorful";
        };

        Security = {
          ClearClipboardTimeout = 15;
          EnableCopyOnDoubleClick = true;
          IconDownloadFallback = true;
          LockDatabaseScreenLock = false;
        };

        SSHAgent.Enabled = true;
      };

      settings = defaults // config.myHome.apps.keepassxc.settings;
    in
      lib.generators.toINI {} settings;
  };
}
