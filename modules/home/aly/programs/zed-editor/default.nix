{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.aly.programs.zed-editor.enable = lib.mkEnableOption "zed editor";

  config = lib.mkIf config.myHome.aly.programs.zed-editor.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = with pkgs; [
        gopls
        nixd
      ];

      installRemoteServer = true;

      userKeymaps = [
        {
          context = "Workspace";

          bindings = {
            cmd-p = "command_palette::Toggle";
            cmd-shift-p = "file_finder::Toggle";
            ctrl-p = "command_palette::Toggle";
            ctrl-shift-p = "file_finder::Toggle";
          };
        }
      ];

      userSettings = {
        auto_indent_on_paste = true;
        auto_update = false;
        autosave.after_delay.milliseconds = 1000;

        # buffer_font_family = "CaskaydiaCove Nerd Font";
        # buffer_font_size = 16;

        features.edit_prediction_provider = "copilot";
        minimap.show = "auto";
        preferred_line_length = 80;
        soft_wrap = "preferred_line_length";

        # theme = {
        #   mode = "system";
        #   light = "One Light";
        #   dark = "One Dark";
        # };

        # ui_font_size = 16;
        use_on_type_format = true;
        wrap_guides = [80];
      };
    };
  };
}
