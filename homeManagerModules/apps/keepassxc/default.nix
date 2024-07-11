{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.keepassxc.enable {
    home.packages = [pkgs.keepassxc];

    ar.home.apps.keepassxc.settings = lib.mkDefault {
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

    xdg.configFile."keepassxc/keepassxc.ini".text =
      lib.generators.toINI {}
      config.ar.home.apps.keepassxc.settings;
  };
}
