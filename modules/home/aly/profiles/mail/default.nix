{
  config,
  lib,
  pkgs,
  ...
}: let
  mkPassword = secret: "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${secret}";
in {
  options.myHome.aly.profiles.mail.enable = lib.mkEnableOption "mail";

  config = lib.mkIf config.myHome.aly.profiles.mail.enable {
    sops.secrets = {
      achacegaGmail = {
        sopsFile = ../../../../../secrets/mail.yaml;
        key = "gmail";
      };

      alyraffaufFastmail = {
        sopsFile = ../../../../../secrets/mail.yaml;
        key = "fastmail";
      };
    };

    accounts.email.accounts = {
      "alyraffauf@fastmail.com" = {
        address = "alyraffauf@fastmail.com";
        aliases = ["aly@aly.codes" "aly@raffauflabs.com"];
        flavor = "fastmail.com";
        himalaya.enable = true;
        passwordCommand = mkPassword config.sops.secrets.alyraffaufFastmail.path;
        primary = true;
        realName = "Aly Raffauf";

        signature = {
          text = ''
            Thank you,
            Aly Raffauf
            https://aly.codes
          '';

          showSignature = "append";
        };

        thunderbird = lib.mkIf config.myHome.aly.programs.thunderbird.enable {
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
        passwordCommand = mkPassword config.sops.secrets.achacegaGmail.path;
        realName = "Aly Raffauf";

        signature = {
          text = ''
            --
            Aly Raffauf (née Chace)
          '';

          showSignature = "append";
        };

        thunderbird = lib.mkIf config.myHome.aly.programs.thunderbird.enable {
          enable = true;
          profiles = ["default"];
        };

        userName = "achacega@gmail.com";
      };
    };

    programs.himalaya.enable = true;
  };
}
