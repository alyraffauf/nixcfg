{
  config,
  cosmicLib,
  lib,
  ...
}: {
  options.myHome.aly.desktop.cosmic = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.myHome.desktop.cosmic.enable && config.home.username == "aly";
      description = "Enable Aly's COSMIC desktop environment.";
    };
  };

  config = lib.mkIf config.myHome.desktop.cosmic.enable {
    dconf = {
      enable = true;

      settings = {
        "org/cosmic/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,close";
        };
      };
    };

    # programs.cosmic-term.settings.app_theme = cosmicLib.cosmic.mkRON "enum" "Dark";

    programs.cosmic-term = {
      enable = true;

      profiles = [
        {
          hold = false;
          is_default = true;
          name = "Default";
          syntax_theme_dark = "COSMIC Dark";
          syntax_theme_light = "COSMIC Light";
          working_directory = config.home.homeDirectory;
        }
      ];

      settings = {
        app_theme = cosmicLib.cosmic.mkRON "enum" "Dark";
        show_headerbar = false;
      };
    };

    wayland.desktopManager.cosmic = {
      enable = true;

      compositor = {
        active_hint = false;
        autotile = false;
        autotile_behavior = cosmicLib.cosmic.mkRON "enum" "PerWorkspace";
        edge_snap_threshold = 10;

        input_touchpad = {
          click_method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "Clickfinger");

          scroll_config = cosmicLib.cosmic.mkRON "optional" {
            method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "TwoFinger");
            natural_scroll = cosmicLib.cosmic.mkRON "optional" true;
            scroll_button = cosmicLib.cosmic.mkRON "optional" null;
            scroll_factor = cosmicLib.cosmic.mkRON "optional" null;
          };

          state = cosmicLib.cosmic.mkRON "enum" "Enabled";
        };

        workspaces = {
          workspace_layout = cosmicLib.cosmic.mkRON "enum" "Vertical";
          workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";
        };
      };

      panels = [
        {
          anchor = cosmicLib.cosmic.mkRON "enum" "Left";
          anchor_gap = false;

          autohide = cosmicLib.cosmic.mkRON "optional" {
            handle_size = 4;
            transition_time = 200;
            unhide_delay = 200;
            wait_time = 1000;
          };

          background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
          expand_to_edges = false;
          name = "Dock";
          opacity = 1.0;
          output = cosmicLib.cosmic.mkRON "enum" "All";
          padding = 0;

          plugins_center = cosmicLib.cosmic.mkRON "optional" [
            "com.system76.CosmicPanelLauncherButton"
            "com.system76.CosmicAppList"
          ];

          plugins_wings = cosmicLib.cosmic.mkRON "optional" null;
          size = cosmicLib.cosmic.mkRON "enum" "L";
          size_center = cosmicLib.cosmic.mkRON "optional" null;
          size_wings = cosmicLib.cosmic.mkRON "optional" null;
          spacing = 4;
        }

        {
          anchor = cosmicLib.cosmic.mkRON "enum" "Top";
          anchor_gap = false;
          autohide = cosmicLib.cosmic.mkRON "optional" null;
          background = cosmicLib.cosmic.mkRON "enum" "ThemeDefault";
          expand_to_edges = true;
          name = "Panel";
          opacity = 1.0;
          output = cosmicLib.cosmic.mkRON "enum" "All";
          padding = 0;

          plugins_center = cosmicLib.cosmic.mkRON "optional" [
            "com.system76.CosmicAppletTime"
          ];

          plugins_wings = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "tuple" [
            [
              "com.system76.CosmicPanelWorkspacesButton"
              "com.system76.CosmicPanelAppButton"
              "com.system76.CosmicAppletWorkspaces"
            ]
            [
              "com.system76.CosmicAppletInputSources"
              "com.system76.CosmicAppletStatusArea"
              "com.system76.CosmicAppletTiling"
              "com.system76.CosmicAppletAudio"
              "com.system76.CosmicAppletBluetooth"
              "com.system76.CosmicAppletNetwork"
              "com.system76.CosmicAppletBattery"
              "com.system76.CosmicAppletNotifications"
              "com.system76.CosmicAppletPower"
            ]
          ]);

          size = cosmicLib.cosmic.mkRON "enum" "XS";
          size_center = cosmicLib.cosmic.mkRON "optional" null;
          size_wings = cosmicLib.cosmic.mkRON "optional" null;
          spacing = 4;
        }
      ];
    };
  };
}
