_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: {
    files.files = [
      {
        checkFile = false;
        path_ = ".vscode/extensions.json";

        drv = (pkgs.formats.json {}).generate "vscode-extensions.json" {
          recommendations = [
            "esbenp.prettier-vscode"
            "foxundermoon.shell-format"
            "jnoortheen.nix-ide"
            "mads-hartmann.bash-ide-vscode"
            "mkhl.direnv"
          ];
        };
      }
      {
        checkFile = false;
        path_ = ".vscode/settings.json";

        drv = (pkgs.formats.json {}).generate "vscode-setting.json" {
          editor = {
            formatOnPaste = true;
            formatOnSave = true;
            formatOnType = true;
          };

          nix = {
            enableLanguageServer = true;
            formatterPath = lib.getExe pkgs.alejandra;
            serverPath = lib.getExe pkgs.nixd;
            serverSettings.nixd.formatting.command = [(lib.getExe pkgs.alejandra)];
          };

          "[shellscript]" = {
            editor.defaultFormatter = "foxundermoon.shell-format";
            editor.formatOnSave = true;
          };

          shellformat = {
            path = lib.getExe pkgs.shfmt;
            flag = "-i 2";
          };

          "[markdown]" = {
            editor.defaultFormatter = "esbenp.prettier-vscode";
            editor.formatOnSave = true;
          };
        };
      }
      {
        checkFile = false;
        path_ = ".vscode/tasks.json";

        drv = (pkgs.formats.json {}).generate "vscode-tasks.json" {
          version = "2.0.0";
          tasks = [
            {
              label = "Evaluate Flake";
              type = "shell";
              command = "nix";
              args = ["flake" "check" "--all-systems"];

              group = {
                kind = "build";
                isDefault = true;
              };

              presentation = {
                echo = true;
                reveal = "silent";
                focus = false;
                panel = "shared";
              };

              problemMatcher = [];
            }
            {
              label = "Rebuild NixOS";
              type = "shell";
              command = "nh";
              args = ["os" "test"];

              group = {
                kind = "build";
                isDefault = false;
              };

              presentation = {
                echo = true;
                reveal = "always";
                focus = true;
                panel = "shared";
              };

              problemMatcher = [];
            }
            {
              label = "Rebuild Darwin";
              type = "shell";
              command = "nh";
              args = ["darwin" "switch" "."];

              group = {
                kind = "build";
                isDefault = false;
              };

              presentation = {
                echo = true;
                reveal = "always";
                focus = true;
                panel = "shared";
              };

              problemMatcher = [];
            }
            {
              label = "Format Repository";
              type = "shell";
              command = "nix";
              args = ["fmt"];

              group = {
                kind = "none";
                isDefault = false;
              };

              presentation = {
                echo = true;
                reveal = "silent";
                focus = false;
                panel = "shared";
              };

              problemMatcher = [];
            }
          ];
        };
      }
    ];
  };
}
