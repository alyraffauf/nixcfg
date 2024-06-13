{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.keepassxc.enable {
    home = {
      file.".cache/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
        General.LastActiveDatabase = "/${config.home.homeDirectory}/sync/Passwords.kdbx";
      };
      packages = [pkgs.keepassxc];
    };

    xdg.configFile."keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
      Browser = {
        AlwaysAllowAccess = true;
        Enabled = true;
        SearchInAllDatabases = true;
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
        MinimizeOnStartup = false;
        MinimizeToTray = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "colorful";
      };

      Security = {
        ClearClipboardTimeout = 15;
        EnableCopyOnDoubleClick = true;
        IconDownloadFallback = true;
        LockDatabaseScreenLock = true;
      };

      SSHAgent = {
        Enabled = true;
      };
    };
  };
}
