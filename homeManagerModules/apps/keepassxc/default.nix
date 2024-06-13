{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.keepassxc.enable {
    home.packages = [pkgs.keepassxc];
    xdg.configFile."keepassxc/keepassxc.ini".text = ''
      [General]
      ConfigVersion=2
      HideWindowOnCopy=true
      MinimizeAfterUnlock=false
      MinimizeOnOpenUrl=true

      [Browser]
      AlwaysAllowAccess=true
      CustomProxyLocation=
      Enabled=true
      SearchInAllDatabases=true

      [GUI]
      ApplicationTheme=classic
      ColorPasswords=false
      CompactMode=true
      MinimizeOnClose=true
      MinimizeOnStartup=false
      MinimizeToTray=true
      ShowTrayIcon=true
      TrayIconAppearance=colorful

      [PasswordGenerator]
      AdditionalChars=
      ExcludedChars=

      [SSHAgent]
      Enabled=true

      [Security]
      ClearClipboardTimeout=15
      EnableCopyOnDoubleClick=true
      IconDownloadFallback=true
      LockDatabaseScreenLock=true
    '';
  };
}
