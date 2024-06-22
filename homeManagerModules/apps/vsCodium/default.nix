{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.alyraffauf.apps.vsCodium.enable {
    alyraffauf.apps.alacritty.enable = lib.mkDefault true;

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'NotoSansM Nerd Font','${config.alyraffauf.theme.terminalFont.name}', 'monospace', monospace";
        "editor.fontSize" = lib.mkDefault 14;
        "terminal.integrated.fontSize" = lib.mkDefault 14;
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;
        "terminal.external.linuxExec" = config.alyraffauf.defaultApps.terminal.exe;
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";
        "window.zoomPerWindow" = false;
        "workbench.colorTheme" =
          if config.alyraffauf.theme.colors.preferDark
          then "Catppuccin Frappé"
          else "Catppuccin Latte";
        "workbench.iconTheme" =
          if config.alyraffauf.theme.colors.preferDark
          then "catppuccin-frappe"
          else "catppuccin-latte";
        "workbench.preferredDarkColorTheme" = "Catppuccin Frappé";
        "workbench.preferredLightColorTheme" = "Catppuccin Latte";
      };

      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        coolbear.systemd-unit-file
        github.vscode-github-actions
        github.vscode-pull-request-github
        jnoortheen.nix-ide
        justusadam.language-haskell
        ms-python.python
        ms-vscode.cpptools-extension-pack
        oderwat.indent-rainbow
        rubymaniac.vscode-paste-and-indent
        rust-lang.rust-analyzer
        tomoki1207.pdf
      ];
    };
  };
}
