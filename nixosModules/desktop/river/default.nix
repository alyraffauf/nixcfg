{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.desktop.river.enable {
    programs.river = {
      enable = true;
      extraPackages = lib.mkDefault [];
    };
  };
}
