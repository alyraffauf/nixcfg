{...}: {
  config = {
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
