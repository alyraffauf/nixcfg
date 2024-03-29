{ pkgs, lib, config, ... }: {

  options = { guiApps.vsCode.enable = lib.mkEnableOption "Enables VSCodium."; };

  config = lib.mkIf config.guiApps.vsCode.enable {

    # Necessary fonts.
    home.packages = with pkgs; [
        pkgs.nerdfonts.override { fonts = [ "Noto" ]; };
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      userSettings = {
        "update.mode" = "none";
        "workbench.colorTheme" = "Catppuccin Macchiato";
        "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "files.autoSave" = "afterDelay";
        "workbench.preferredLightColorTheme" = "Catppuccin Latte";
        "window.zoomPerWindow" = false;
        "explorer.confirmDelete" = false;
        "workbench.iconTheme" = "catppuccin-macchiato";
        "editor.fontFamily" =
          "'NotoSansM Nerd Font', 'monospace', monospace";
        "window.menuBarVisibility" = "hidden";
        "diffEditor.ignoreTrimWhitespace" = false;
      };

      extensions = with pkgs; [
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.catppuccin.catppuccin-vsc-icons
        vscode-extensions.github.vscode-github-actions
        vscode-extensions.github.vscode-pull-request-github
        vscode-extensions.ms-python.python
        vscode-extensions.ms-vscode.cpptools-extension-pack
        vscode-extensions.rubymaniac.vscode-paste-and-indent
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.tomoki1207.pdf
      ];
    };
  };
}
