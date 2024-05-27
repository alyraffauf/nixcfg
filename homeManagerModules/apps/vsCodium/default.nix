{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    alyraffauf.apps.vsCodium.enable = lib.mkEnableOption "Enables VSCodium.";
  };

  config = lib.mkIf config.alyraffauf.apps.vsCodium.enable {
    alyraffauf.apps.alacritty.enable = lib.mkDefault true;

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'NotoSansM Nerd Font','${config.alyraffauf.desktop.theme.terminalFont.name}', 'monospace', monospace";
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;
        "terminal.external.linuxExec" = config.alyraffauf.desktop.defaultApps.terminal.exe;
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";
        "window.zoomPerWindow" = false;
        "workbench.colorTheme" =
          if config.alyraffauf.desktop.theme.colors.preferDark
          then "Catppuccin Frappé"
          else "Catppuccin Latte";
        "workbench.iconTheme" =
          if config.alyraffauf.desktop.theme.colors.preferDark
          then "catppuccin-frappe"
          else "catppuccin-latte";
        "workbench.preferredDarkColorTheme" = "Catppuccin Frappé";
        "workbench.preferredLightColorTheme" = "Catppuccin Latte";
      };

      extensions = with pkgs; [
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.catppuccin.catppuccin-vsc-icons
        vscode-extensions.github.vscode-github-actions
        vscode-extensions.github.vscode-pull-request-github
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.justusadam.language-haskell
        vscode-extensions.ms-python.python
        vscode-extensions.ms-vscode.cpptools-extension-pack
        vscode-extensions.rubymaniac.vscode-paste-and-indent
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.tomoki1207.pdf
      ];
    };
  };
}
