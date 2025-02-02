{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.keepassxc = {
    enable = lib.mkEnableOption "KeePassXC password manager.";
    package = lib.mkPackageOption pkgs "keepassxc" {};

    settings = lib.mkOption {
      description = "KeePassXC settings.";
      default = {};
      type = lib.types.attrs;
    };
  };

  config = lib.mkIf config.myHome.programs.keepassxc.enable {
    home.packages = [config.myHome.programs.keepassxc.package];

    programs.firefox.nativeMessagingHosts = [pkgs.keepassxc];

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

      settings = defaults // config.myHome.programs.keepassxc.settings;
    in
      lib.generators.toINI {} settings;
  };
}
