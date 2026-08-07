{
  config,
  pkgs,
  lib,
  ...
}: {
  options.myHome.services.raycast = {
    enable = lib.mkEnableOption "raycast";
    package = lib.mkPackageOption pkgs "raycast" {};
  };

  config = lib.mkIf config.myHome.services.raycast.enable {
    home.packages = [config.myHome.services.raycast.package];

    launchd.agents.raycast = {
      enable = true;

      config = {
        KeepAlive = true;
        ProcessType = "Interactive";

        ProgramArguments = [
          "${config.home.homeDirectory}/Applications/Home Manager Apps/${config.myHome.services.raycast.package.sourceRoot}/Contents/MacOS/Raycast"
        ];

        StandardErrorPath = "${config.xdg.cacheHome}/raycast.log";
        StandardOutPath = "${config.xdg.cacheHome}/raycast.log";
      };
    };

    targets.darwin.defaults = {
      "com.apple.Spotlight".MenuItemHidden = true;

      "com.apple.symbolichotkeys" = {
        # Disable spotlight hotkeys
        AppleSymbolicHotKeys = {
          "64".enabled = false; # Cmd-Space
          "65".enabled = false; # Option/Ctrl-Cmd-Space
        };
      };

      "com.raycast.macos" = {
        "NSStatusItem Visible raycastIcon" = 0;
        "permissions.folders.read:${config.home.homeDirectory}/Desktop" = true;
        "permissions.folders.read:${config.home.homeDirectory}/Documents" = true;
        "permissions.folders.read:${config.home.homeDirectory}/Downloads" = true;
        "permissions.folders.read:cloudStorage" = true;
        "permissions.folders.read:removableVolumes" = true;
        navigationCommandStyleIdentifierKey = "macos";
        onboardingCompleted = true;
        raycastGlobalHotkey = "Command-49";
        raycastPreferredWindowMode = "compact";
      };
    };
  };
}
