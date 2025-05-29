{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  mkPassword = secret: "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${secret}";
in {
  imports = [
    self.inputs.agenix.homeManagerModules.default
  ];

  options.myHome.aly.profiles.mail.enable = lib.mkEnableOption "mail";

  config = lib.mkIf config.myHome.aly.profiles.mail.enable {
    age.secrets = {
      achacegaGmail.file = "${self.inputs.secrets}/aly/mail/gmail.age";
      alyraffaufFastmail.file = "${self.inputs.secrets}/aly/mail/fastmail.age";
    };

    accounts.email.accounts = {
      "alyraffauf@fastmail.com" = {
        address = "alyraffauf@fastmail.com";
        aliases = ["aly@aly.codes" "aly@raffauflabs.com"];
        flavor = "fastmail.com";
        himalaya.enable = true;
        passwordCommand = mkPassword config.age.secrets.alyraffaufFastmail.path;
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
        passwordCommand = mkPassword config.age.secrets.achacegaGmail.path;
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
