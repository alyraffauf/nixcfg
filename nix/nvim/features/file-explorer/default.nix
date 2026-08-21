# Provide the left-hand filesystem, buffer, and Git tree.
_: {
  flake.neovimModules.default = {
    config.vim = {
      filetree.neo-tree = {
        enable = true;
        setupOpts = {
          close_if_last_window = true;
          window = {
            position = "left";
            width = 32;
          };
          filesystem = {
            bind_to_cwd = true;
            follow_current_file.enabled = true;
            filtered_items = {
              hide_dotfiles = false;
              hide_gitignored = true;
            };
          };
          source_selector = {
            winbar = true;
            content_layout = "center";
            sources = [
              {
                source = "filesystem";
                display_name = " 󰉓 Files ";
              }
              {
                source = "buffers";
                display_name = " 󰈚 Buffers ";
              }
              {
                source = "git_status";
                display_name = " 󰊢 Git ";
              }
            ];
          };
        };
      };
      extraLuaFiles = [./config.lua];
    };
  };
}
