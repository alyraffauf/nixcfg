{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.fontix.homeModules.default
    self.inputs.catppuccin.homeModules.catppuccin
  ];

  age.secrets = {
    syncthingCert.file = "${self.inputs.secrets}/aly/syncthing/pacifidlog/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/aly/syncthing/pacifidlog/key.age";
  };

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      obsidian
      plexamp
      signal-desktop-bin
    ];

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

  nixGL = {
    inherit (self.inputs.nixgl) packages;
    vulkan.enable = true;
  };

  programs = {
    home-manager.enable = true;
    firefox.package = lib.mkForce (config.lib.nixGL.wrap pkgs.firefox);
    ghostty.package = lib.mkForce (config.lib.nixGL.wrap pkgs.ghostty);
    zed-editor.package = config.lib.nixGL.wrap pkgs.zed-editor;
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

        "roms" = {
          enable = lib.mkForce false;
          path = "/home/aly/ROMs";
        };

        "screenshots".enable = lib.mkForce false;
        "sync".path = lib.mkForce "/home/aly/sync";
      }
    ];
  in {
    enable = true;
    cert = config.age.secrets.syncthingCert.path;
    key = config.age.secrets.syncthingKey.path;

    settings = {
      options = {
        localAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = -1;
      };

      inherit devices folders;
    };
  };

  xdg.enable = true;

  fontix = {
    fonts = {
      monospace = {
        name = "CaskaydiaCove Nerd Font";
        package = pkgs.nerd-fonts.caskaydia-cove;
      };

      sansSerif = {
        name = "Adwaita";
        package = pkgs.adwaita-fonts;
      };

      serif = {
        name = "Source Serif Pro";
        package = pkgs.source-serif-pro;
      };
    };

    sizes = {
      applications = 10;
      desktop = 10;
    };

    font-packages.enable = true;
    fontconfig.enable = true;
    ghostty.enable = true;
    gnome.enable = true;
    gtk.enable = true;
    halloy.enable = true;
    vscode.enable = true;
    zed-editor.enable = true;
  };

  catppuccin = {
    flavor = "macchiato";
    bat.enable = true;
    helix.enable = true;
    ghostty.enable = true;
    lazygit.enable = true;
    vesktop.enable = true;
    # vscode.profiles.default.enable = true;

    zed = {
      enable = true;
      icons.enable = true;
      italics = false;
    };

    zellij.enable = true;
  };

  myHome = {
    aly = {
      profiles.mail.enable = true;

      programs = {
        awscli.enable = true;
        firefox.enable = true;
        git.enable = true;
        halloy.enable = true;
        helix.enable = true;
        ssh.enable = true;
        thunderbird.enable = true;
        vesktop.enable = true;
        vsCode.enable = true;
        zed-editor.enable = true;
      };
    };

    desktop.gnome.enable = true;

    profiles = {
      defaultApps = {
        enable = true;
        editor.package = config.programs.zed-editor.package;
        terminal.package = config.programs.ghostty.package;

        webBrowser = {
          exec = lib.getExe config.programs.firefox.finalPackage;
          package = config.programs.firefox.finalPackage;
        };
      };
      shell.enable = true;
    };

    programs = {
      fastfetch.enable = true;
      ghostty.enable = true;
    };
  };
}
