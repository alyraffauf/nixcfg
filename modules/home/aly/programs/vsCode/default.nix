{
  config,
  pkgs,
  lib,
  ...
}: {
  options.myHome.aly.programs.vsCode.enable = lib.mkEnableOption "vsCode editor";

  config = lib.mkIf config.myHome.aly.programs.vsCode.enable {
    programs.vscode = {
      enable = true;

      profiles.default = {
        enableUpdateCheck = false;
        enableExtensionUpdateCheck = false;

        extensions = with pkgs.vscode-extensions; [
          github.vscode-github-actions
          github.vscode-pull-request-github
          ms-vscode-remote.remote-ssh
          oderwat.indent-rainbow
          rubymaniac.vscode-paste-and-indent
        ];

        keybindings = let
          mod =
            if pkgs.stdenv.isDarwin
            then "cmd"
            else "ctrl";
        in [
          {
            "key" = "alt+e";
            "command" = "workbench.action.quickOpen";
          }
          {
            "key" = "${mod}+p";
            "command" = "-workbench.action.quickOpen";
          }
          {
            "key" = "${mod}+p";
            "command" = "workbench.action.showCommands";
          }
          {
            "key" = "${mod}+shift+t";
            "command" = "-workbench.action.reopenClosedEditor";
          }
          {
            "key" = "${mod}+shift+t";
            "command" = "workbench.action.tasks.runTask";
          }
          {
            "key" = "${mod}+shift+p";
            "command" = "-workbench.action.showCommands";
          }
        ];

        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "direnv.restart.automatic" = true;
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
          "window.menuBarVisibility" = "hidden";

          "window.titleBarStyle" =
            if (config.myHome.desktop.gnome.enable || config.myHome.desktop.cosmic.enable || pkgs.stdenv.isDarwin)
            then "custom"
            else "native";
        };
      };
    };

    stylix.targets.vscode.profileNames = ["default"];
  };
}
