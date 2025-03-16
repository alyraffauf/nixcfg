{
  config,
  lib,
  ...
}: {
  options.myDarwin.desktop.aerospace.enable = lib.mkEnableOption "Aerospace tiling window manager.";

  config = lib.mkIf config.myDarwin.desktop.aerospace.enable {
    services.aerospace = {
      enable = true;

      settings = {
        enable-normalization-flatten-containers = false;
        enable-normalization-opposite-orientation-for-nested-containers =
          false;

        gaps = {
          inner.horizontal = 8;
          inner.vertical = 8;
          outer.bottom = 8;
          outer.left = 8;
          outer.right = 8;
          outer.top = 8;
        };

        mode = {
          main.binding = {
            alt-0 = "workspace 10";
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-h = "focus --boundaries-action wrap-around-the-workspace left";
            alt-j = "focus --boundaries-action wrap-around-the-workspace down";
            alt-k = "focus --boundaries-action wrap-around-the-workspace up";
            alt-l = "focus --boundaries-action wrap-around-the-workspace right";
            alt-leftSquareBracket = "split horizontal";
            alt-r = "mode resize";
            alt-rightSquareBracket = "split vertical";
            alt-shift-0 = ["move-node-to-workspace 10" "workspace 10"];
            alt-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
            alt-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
            alt-shift-3 = ["move-node-to-workspace 3" "workspace 3"];
            alt-shift-4 = ["move-node-to-workspace 4" "workspace 4"];
            alt-shift-5 = ["move-node-to-workspace 5" "workspace 5"];
            alt-shift-6 = ["move-node-to-workspace 6" "workspace 6"];
            alt-shift-7 = ["move-node-to-workspace 7" "workspace 7"];
            alt-shift-8 = ["move-node-to-workspace 8" "workspace 8"];
            alt-shift-9 = ["move-node-to-workspace 9" "workspace 9"];
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";
            alt-shift-v = "layout floating tiling";
            alt-shift-w = "fullscreen";
            alt-v = "layout tiles";
          };

          resize.binding = {
            alt-h = "resize width -50";
            alt-j = "resize height +50";
            alt-k = "resize height -50";
            alt-l = "resize width +50";
            enter = "mode main";
            esc = "mode main";
          };
        };

        on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      };
    };
  };
}
