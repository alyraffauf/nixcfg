{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome;
in {
  options.myHome.programs.vsCodium.enable = lib.mkEnableOption "VSCodium text editor.";

  config = lib.mkIf config.myHome.programs.vsCodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      keybindings = [
        {
          "key" = "alt+e";
          "command" = "workbench.action.quickOpen";
        }
        {
          "key" = "ctrl+p";
          "command" = "-workbench.action.quickOpen";
        }
        {
          "key" = "ctrl+p";
          "command" = "workbench.action.showCommands";
        }
        {
          "key" = "ctrl+shift+p";
          "command" = "-workbench.action.showCommands";
        }
      ];

      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.fontSize" = lib.mkForce (config.stylix.fonts.sizes.applications + 3);
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.rulers" = [80];
        "editor.wordWrap" = "wordWrapColumn";
        "editor.wordWrapColumn" = 80;
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;
        "git.confirmSync" = false;

        "nix" = {
          "enableLanguageServer" = true;
          "formatterPath" = lib.getExe pkgs.alejandra;
          "serverPath" = lib.getExe pkgs.nixd;

          "serverSettings" = {
            "nil" = {
              "diagnostics" = {
                "ignored" = ["unused_binding" "unused_with"];
              };

              "formatting" = {
                "command" = ["${lib.getExe pkgs.alejandra}"];
              };
            };

            "nixd" = {
              "formatting" = {
                "command" = ["${lib.getExe pkgs.alejandra}"];
              };
            };
          };
        };

        "[shellscript]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };

        "shellformat.flag" = "-i 4";
        "terminal.external.linuxExec" = lib.getExe cfg.defaultApps.terminal;
        "terminal.integrated.fontSize" = lib.mkForce (config.stylix.fonts.sizes.terminal + 3);
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";
        "window.titleBarStyle" = lib.mkDefault "native";
        "window.zoomPerWindow" = false;
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
        rubymaniac.vscode-paste-and-indent
        rust-lang.rust-analyzer
        tomoki1207.pdf
      ];
    };
  };
}
