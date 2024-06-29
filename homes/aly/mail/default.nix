{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  genPassword = secret: "${lib.getExe' pkgs.coreutils "cat"} ${secret}";
in {
  accounts.email.accounts = {
    fastmail = {
      address = "alyraffauf@fastmail.com";
      aliases = ["aly@raffauflabs.com"];
      flavor = "fastmail.com";
      passwordCommand = genPassword osConfig.age.secrets.alyraffaufFastmail.path;
      primary = true;
      realName = "Aly Raffauf";
      thunderbird = {
        enable = true;
        profiles = ["default"];
      };
      userName = "alyraffauf@fastmail.com";
      himalaya.enable = true;
    };
  };

  programs = {
    himalaya.enable = true;

    thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };
  };
}
