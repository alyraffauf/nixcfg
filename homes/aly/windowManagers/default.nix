{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager = {
    sway.config = {
      assigns = {
        "workspace 1: web" = [{app_id = "firefox";} {app_id = "brave-browser";}];
        "workspace 2: code" = [{app_id = "codium-url-handler";}];
        "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
        "workspace 4: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";} {app_id = "firework";}];
        "workspace 10: zoom" = [{class = "zoom";} {app_id = "Zoom";}];
      };

      startup = [
        {command = ''${lib.getExe' pkgs.keepassxc "keepassxc"}'';}
      ];
    };

    hyprland.extraConfig = ''
      # Workspace - Browser
      workspace = 1, defaultName:web, on-created-empty:${config.ar.home.defaultApps.webBrowser.exe}
      windowrulev2 = workspace 1,class:(firefox)
      windowrulev2 = workspace 1,class:(brave-browser)

      # Workspace - Coding
      workspace = 2, defaultName:code, on-created-empty:${config.ar.home.defaultApps.editor.exe}
      windowrulev2 = workspace 2,class:(codium-url-handler)

      # Workspace - Work
      windowrulev2 = workspace 3,class:(google-chrome)
      windowrulev2 = workspace 3,class:(firework)

      # Scratchpad Chat
      # bind = SUPER, S, togglespecialworkspace, magic
      # bind = SUPER SHIFT, W, movetoworkspace, special:magic
      workspace = special:magic, on-created-empty:${lib.getExe pkgs.fractal}
      windowrulev2 = workspace special:magic,class:(org.gnome.Fractal)
      windowrulev2 = workspace special:magic,class:(WebCord)

      # Scratchpad Notes
      bind = SUPER, N, togglespecialworkspace, notes
      bind = SUPER SHIFT, N, movetoworkspace, special:notes
      workspace = special:notes, on-created-empty:${lib.getExe' pkgs.obsidian "obsidian"}
      # windowrulev2 = workspace special:notes,class:(obsidian)

      # # Scratchpad Music
      # bind = SUPER, P, togglespecialworkspace, music
      # bind = SUPER SHIFT, P, movetoworkspace, special:music
      # workspace = special:music, on-created-empty:${lib.getExe' pkgs.plexamp "plexamp"}
      # windowrulev2 = workspace special:music,class:(Plexamp)
    '';
  };
}
