{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./firefox
    ./git
    ./halloy
    ./helix
    ./mail
    ./secrets.nix
    ./vsCode
    ./zen
    self.homeManagerModules.default
    self.homeManagerModules.snippets
    self.inputs.agenix.homeManagerModules.default
  ];

  home = {
    packages = with pkgs; [
      curl
      rclone
      wget
    ];

    username = "aly";
  };

  programs = {
    awscli = {
      enable = true;

      credentials = {
        "default" = {
          "credential_process" = ''sh -c "${lib.getExe' pkgs.uutils-coreutils-noprefix "cat"} ${config.age.secrets.aws.path}"'';
        };
      };
    };

    home-manager.enable = true;

    vesktop = {
      enable = true;

      settings = {
        appBadge = false;
        arRPC = true;
        disableMinSize = true;
        minimizeToTray = false;
        tray = false;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };

      vencord.settings = {
        autoUpdate = true;
        autoUpdateNotification = false;
        disableMinSize = true;
        notifyAboutUpdates = false;

        plugins = {
          AlwaysTrust.enabled = true;
          BlurNSFW.enabled = true;
          ClearURLs.enabled = true;
          FakeNitro.enabled = true;
          PinDMs.enabled = true;
          WebKeybinds.enabled = true;
          WebScreenShareFixes.enabled = true;
        };

        useQuickCss = true;
      };
    };
  };

  myHome = {
    profiles.shell.enable = true;

    programs = {
      fastfetch.enable = true;
      ghostty.enable = true;
    };
  };
}
