{
  config,
  inputs,
  lib,
  pkgs,
  self,
  ...
}: {
  home = {
    homeDirectory = "/home/aly";

    file."${config.xdg.cacheHome}/keepassxc/keepassxc.ini".text = lib.generators.toINI {} {
      General.LastActiveDatabase = "${config.home.homeDirectory}/sync/Passwords.kdbx";
    };

    packages = with pkgs; [
      browsh
      curl
      fractal
      gh
      git
      google-chrome
      obsidian
      plexamp
      python3
      ruby
      tauon
      trayscale
      webcord
      wget
    ];

    stateVersion = "24.05";
    username = "aly";
  };

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;
      profiles.work = {
        id = 1;

        search = {
          default = "Google";
          force = true;
          engines = {
            "Bing" = {
              metaData = {
                hidden = true;
                alias = "!bing";
              };
            };
            "DuckDuckGo" = {
              metaData = {
                hidden = true;
                alias = "!ddg";
              };
            };
          };
        };
      };
      profiles.default = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          augmented-steam
          decentraleyes
          keepassxc-browser
          omnivore
          sidebery
          sponsorblock
          ublock-origin
          zoom-redirector
        ];

        id = 0;

        search = {
          default = "DuckDuckGo";
          force = true;
          engines = {
            "nixpkgs" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["!nix"];
            };

            "Bing" = {
              metaData = {
                hidden = true;
                alias = "!bing";
              };
            };
            "Google" = {
              metaData = {
                hidden = true;
                alias = "!google";
              };
            };
          };
        };

        settings = {
          "network.cookie.cookieBehavior" = 1;
          "permissions.default.desktop-notification" = 2;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.global-checkbox.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "services.sync.prefs.sync.browser.uiCustomization.state" = true;

          # "browser.uiCustomization.state" = ''
          #   {
          #       "placements": {
          #           "widget-overflow-fixed-list": [],
          #           "unified-extensions-area": [
          #               "ublock0_raymondhill_net-browser-action",
          #               "sponsorblocker_ajay_app-browser-action",
          #               "_019b606a-6f61-4d01-af2a-cea528f606da_-browser-action",
          #               "jid1-bofifl9vbdl2zq_jetpack-browser-action"
          #           ],
          #           "nav-bar": [
          #               "back-button",
          #               "forward-button",
          #               "stop-reload-button",
          #               "customizableui-special-spring1",
          #               "urlbar-container",
          #               "customizableui-special-spring2",
          #               "downloads-button",
          #               "save-extension_omnivore_app-browser-action",
          #               "keepassxc-browser_keepassxc_org-browser-action",
          #               "_3c078156-979c-498b-8990-85f7987dd929_-browser-action",
          #               "unified-extensions-button",
          #               "fxa-toolbar-menu-button"
          #           ],
          #           "toolbar-menubar": [
          #               "menubar-items"
          #           ],
          #           "TabsToolbar": [
          #               "firefox-view-button",
          #               "tabbrowser-tabs",
          #               "new-tab-button",
          #               "alltabs-button"
          #           ],
          #           "PersonalToolbar": [
          #               "personal-bookmarks"
          #           ]
          #       },
          #       "seen": [
          #           "save-extension_omnivore_app-browser-action",
          #           "_019b606a-6f61-4d01-af2a-cea528f606da_-browser-action",
          #           "sponsorblocker_ajay_app-browser-action",
          #           "developer-button",
          #           "keepassxc-browser_keepassxc_org-browser-action",
          #           "ublock0_raymondhill_net-browser-action",
          #           "jid1-bofifl9vbdl2zq_jetpack-browser-action",
          #           "_3c078156-979c-498b-8990-85f7987dd929_-browser-action"
          #       ],
          #       "dirtyAreaCache": [
          #           "unified-extensions-area",
          #           "nav-bar",
          #           "toolbar-menubar",
          #           "TabsToolbar",
          #           "PersonalToolbar"
          #       ],
          #       "currentVersion": 20,
          #       "newElementCount": 4
          #   }
          # '';
        };
      };
    };

    git = {
      enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";
    };
  };

  wayland.windowManager = {
    sway.config = {
      assigns = {
        "workspace 1: web" = [{app_id = "firefox";} {app_id = "brave-browser";}];
        "workspace 2: code" = [{app_id = "codium-url-handler";}];
        "workspace 3: chat" = [{app_id = "org.gnome.Fractal";} {app_id = "WebCord";}];
        "workspace 4: work" = [{app_id = "google-chrome";} {app_id = "chromium-browser";}];
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

      # Workspace - Chrome
      windowrulev2 = workspace 3,class:(google-chrome)

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

  ar.home = {
    apps = {
      alacritty.enable = true;
      bash.enable = true;
      chromium = {
        enable = true;
        package = pkgs.brave;
      };
      emacs.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      keepassxc.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      vsCodium.enable = true;
    };

    desktop = {
      startupApps = [(lib.getExe' pkgs.keepassxc "keepassxc")];
    };

    scripts = {
      pp-adjuster.enable = true;
    };

    theme = {
      wallpaper = "${config.xdg.dataHome}/backgrounds/wallhaven-3led2d.jpg";
    };
  };
}
