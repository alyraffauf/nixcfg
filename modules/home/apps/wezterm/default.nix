{
  config,
  lib,
  ...
}: {
  options.myHome.programs.wezterm.enable = lib.mkEnableOption "Wezterm terminal.";

  config = lib.mkIf config.myHome.programs.wezterm.enable {
    programs.wezterm = {
      enable = true;

      extraConfig = ''
        return {
          hide_tab_bar_if_only_one_tab = true
        }
      '';
    };
  };
}
