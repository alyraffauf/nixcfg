{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.rbw.enable = lib.mkEnableOption "rbw bitwarden client";

  config = lib.mkIf config.myHome.aly.programs.rbw.enable {
    programs.rbw = {
      enable = true;

      settings = {
        base_url = "https://vault.cute.haus";
        email = "alyraffauf@fastmail.com";
        lock_timeout = 14400;
        pinentry = pkgs.pinentry-gnome3;
      };
    };
  };
}
