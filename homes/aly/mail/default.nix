{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  mkPassword = secret: "${lib.getExe' pkgs.coreutils "cat"} ${secret}";
in {
  accounts.email.accounts = {
    "alyraffauf@fastmail.com" = {
      address = "alyraffauf@fastmail.com";
      aliases = ["aly@raffauflabs.com"];
      flavor = "fastmail.com";
      passwordCommand = mkPassword osConfig.age.secrets.alyraffaufFastmail.path;
      primary = true;
      realName = "Aly Raffauf";

      thunderbird = {
        enable = true;
        profiles = ["default"];
      };

      userName = "alyraffauf@fastmail.com";
    };

    "achacega@gmail.com" = {
      address = "achacega@gmail.com";
      aliases = ["alyraffauf@gmail.com"];
      flavor = "gmail.com";
      himalaya.enable = true;
      passwordCommand = mkPassword osConfig.age.secrets.achacegaGmail.path;
      realName = "Aly Raffauf";

      thunderbird = {
        enable = true;
        profiles = ["default"];
      };

      userName = "achacega@gmail.com";
    };

    "aly.chace@joingsg.com" = {
      address = "aly.chace@joingsg.com";
      flavor = "gmail.com";
      realName = "Aly Raffauf";

      thunderbird = {
        enable = true;
        profiles = ["work"];
      };

      userName = "aly.chace@joingsg.com";
    };
  };

  programs = {
    himalaya.enable = true;

    thunderbird = {
      enable = true;
      profiles = {
        default.isDefault = true;
        work = {};
      };
    };
  };

  xdg.desktopEntries.thunderwork = {
    categories = ["Application" "Network" "Chat" "Email" "Feed" "GTK" "News"];
    exec = "thunderbird -P work --name thunderwork %U";
    comment = "Read and write e-mails or RSS feeds, or manage tasks on calendars.";
    genericName = "Email Client";
    icon = "thunderbird";
    mimeType = ["message/rfc822" "x-scheme-handler/mailto" "text/calendar" "text/x-vcard"];
    name = "Thunderbird (work)";
    startupNotify = true;
    terminal = false;
    settings = {
      StartupWMClass = "thunderwork";
    };
  };
}
