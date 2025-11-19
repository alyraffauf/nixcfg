{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.profiles.appimage.enable = lib.mkEnableOption "appimage support";
  config = lib.mkIf config.myNixOS.profiles.appimage.enable {
    environment.systemPackages = with pkgs; [gearlever];

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
