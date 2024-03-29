{ pkgs, lib, config, ... }: {

  options = {
    guiApps.vsCodium.enable = lib.mkEnableOption "Enables VSCodium.";
  };

  config = lib.mkIf config.guiApps.vsCodium.enable {

    guiApps.alacritty.enable = lib.mkDefault true;

    # Necessary fonts.
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
      nixfmt
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'NotoSansM Nerd Font', 'monospace', monospace";
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "nix.formatterPath" = "nixfmt";
        "terminal.external.linuxExec" = "alacritty";
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";
        "window.zoomPerWindow" = false;
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.iconTheme" = "catppuccin-macchiato";
        "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
        "workbench.preferredLightColorTheme" = "Catppuccin Latte";
      };

      extensions = with pkgs; [
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.catppuccin.catppuccin-vsc-icons
        vscode-extensions.github.vscode-github-actions
        vscode-extensions.github.vscode-pull-request-github
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.ms-python.python
        vscode-extensions.ms-vscode.cpptools-extension-pack
        vscode-extensions.rubymaniac.vscode-paste-and-indent
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.tomoki1207.pdf
      ];
    };
  };
}
