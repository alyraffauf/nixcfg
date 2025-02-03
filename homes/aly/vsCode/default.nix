{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
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
          "key" = "ctrl+shift+t";
          "command" = "-workbench.action.reopenClosedEditor";
        }
        {
          "key" = "ctrl+shift+t";
          "command" = "workbench.action.tasks.runTask";
        }
        {
          "key" = "ctrl+shift+p";
          "command" = "-workbench.action.showCommands";
        }
      ];

      userSettings = {
        "diffEditor.ignoreTrimWhitespace" = false;
        "direnv.restart.automatic" = true;
        "editor.fontSize" = lib.mkForce (config.stylix.fonts.sizes.applications + 3);
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.rulers" = [80];
        "editor.wordWrap" = "wordWrapColumn";
        "editor.wordWrapColumn" = 80;
        "explorer.confirmDelete" = false;
        "files.autoSave" = "afterDelay";
        "git.autoStash" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "github.gitProtocol" = "ssh";

        "[shellscript]" = {
          "editor.defaultFormatter" = "foxundermoon.shell-format";
        };

        "shellformat.flag" = "-i 4";
        "terminal.integrated.fontSize" = lib.mkForce (config.stylix.fonts.sizes.terminal + 3);
        "update.mode" = "none";
        "window.menuBarVisibility" = "hidden";

        "window.titleBarStyle" =
          if config.myHome.desktop.gnome.enable
          then "custom"
          else "native";

        "window.zoomPerWindow" = false;
      };

      extensions = with pkgs.vscode-extensions; [
        foxundermoon.shell-format
        github.vscode-github-actions
        github.vscode-pull-request-github
        jnoortheen.nix-ide
        justusadam.language-haskell
        mkhl.direnv
        ms-python.python
        ms-vscode.cpptools-extension-pack
        oderwat.indent-rainbow
        rubymaniac.vscode-paste-and-indent
        rust-lang.rust-analyzer
        supermaven.supermaven
        tomoki1207.pdf
      ];
    };
  };
}
