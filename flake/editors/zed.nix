_: {
  perSystem = {pkgs, ...}: {
    files.files = [
      {
        path_ = ".zed/settings.json";

        drv = (pkgs.formats.json {}).generate "zed-setting.json" {
          auto_install_extensions = {
            basher = true;
            nix = true;
          };

          languages = {
            JSON = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "prettier";
                  arguments = ["--stdin-filepath" "{buffer_path}"];
                };
              };
            };

            Markdown = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "prettier";
                  arguments = ["--stdin-filepath" "{buffer_path}"];
                };
              };
            };

            Nix = {
              format_on_save = "on";
              formatter = "language_server";
              language_servers = ["nixd" "!nil"];
            };

            "Shell Script" = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "shfmt";
                  arguments = ["--filename" "{buffer_path}" "-i" "2"];
                };
              };
              tab_size = 2;
              hard_tabs = false;
            };

            YAML = {
              format_on_save = "on";
              formatter = {
                external = {
                  command = "prettier";
                  arguments = ["--stdin-filepath" "{buffer_path}"];
                };
              };
            };
          };

          lsp = {
            nixd = {
              settings = {
                formatting = {
                  command = ["alejandra" "--quiet" "--"];
                };
              };
            };
          };
        };
      }
    ];
  };
}
