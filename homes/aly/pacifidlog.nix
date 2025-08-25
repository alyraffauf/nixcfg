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
      applications = 11;
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
