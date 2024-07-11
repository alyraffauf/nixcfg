{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.vsCodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontFamily" = "'NotoSansM Nerd Font', 'monospace', monospace";
        "editor.fontSize" = lib.mkDefault 14;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.rulers" = [80];
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "git.confirmSync" = false;

        "nix" = {
          "enableLanguageServer" = true;
          "formatterPath" = lib.getExe pkgs.alejandra;
          "serverPath" = lib.getExe pkgs.nil;

          "serverSettings"."nil" = {
            "diagnostics" = {
              "ignored" = ["unused_binding" "unused_with"];
            };

            "formatting" = {
              "command" = ["${lib.getExe pkgs.alejandra}"];
            };
          };
        };

        "[shellscript]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };
        "shellformat.flag" = "-i 4";

        "terminal.external.linuxExec" = lib.getExe config.ar.home.defaultApps.terminal;
        "terminal.integrated.fontSize" = lib.mkDefault 14;
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";
        "window.titleBarStyle" =
          if config.ar.home.desktop.gnome.enable || config.ar.home.desktop.cinnamon.enable
          then "custom"
          else "native";
        "window.zoomPerWindow" = false;
        "workbench.colorTheme" =
          if config.ar.home.theme.darkMode
          then "Adwaita Dark"
          else "Adwaita Light";
        "workbench.iconTheme" = "vs-seti";
        "workbench.preferredDarkColorTheme" = "Adwaita Dark";
        "workbench.preferredLightColorTheme" = "Adwaita Light";
      };

      extensions = with pkgs.vscode-extensions; [
        coolbear.systemd-unit-file
        foxundermoon.shell-format
        github.vscode-github-actions
        github.vscode-pull-request-github
        jnoortheen.nix-ide
        justusadam.language-haskell
        ms-python.python
        ms-vscode.cpptools-extension-pack
        oderwat.indent-rainbow
        piousdeer.adwaita-theme
        rubymaniac.vscode-paste-and-indent
        rust-lang.rust-analyzer
        tomoki1207.pdf
      ];
    };
  };
}
