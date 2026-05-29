{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.safari.homeModules.default
  ];

  sops.secrets = {
    syncthingCert = {
      sopsFile = ../../secrets/syncthing/rustboro.yaml;
      key = "cert";
    };

    syncthingKey = {
      sopsFile = ../../secrets/syncthing/rustboro.yaml;
      key = "key";
    };
  };

  home = {
    homeDirectory = "/home/aly";
    sessionVariables.NIXOS_OZONE_WL = "1";
    stateVersion = "25.11";
    username = "aly";
  };

  nix = {
    inherit (config.mySnippets.nix) settings;
    package = pkgs.nix;

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      persistent = true;
      randomizedDelaySec = "60min";
    };
  };

  programs = {
    home-manager.enable = true;
    # zed-editor.package = config.lib.nixGL.wrap pkgs.zed-editor;
  };

  services.syncthing = let
    inherit (config.mySnippets.syncthing) devices;

    folders = lib.mkMerge [
      config.mySnippets.syncthing.folders
      {
        "music" = {
          enable = lib.mkForce false;
          path = "/home/aly/music";
        };

        "roms".path = "/home/aly/ROMs";
        "sync".path = lib.mkForce "/home/aly/sync";
      }
    ];
  in {
    enable = true;
    cert = config.sops.secrets.syncthingCert.path;
    key = config.sops.secrets.syncthingKey.path;

    settings = {
      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = -1;
      };

      inherit devices folders;
    };
  };

  targets.genericLinux = {
    enable = true;

    nixGL = {
      inherit (self.inputs.nixgl) packages;
      vulkan.enable = true;
    };
  };

  xdg.enable = true;
}
