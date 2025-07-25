_: {
  perSystem = {pkgs, ...}: {
    files.files = [
      {
        checkFile = false;
        path_ = ".helix/languages.toml";

        drv = (pkgs.formats.toml {}).generate "helix-languages.toml" {
          language = [
            {
              name = "nix";
              "auto-format" = true;
              formatter = {command = "alejandra";};
              "language-servers" = ["nixd"];
            }
            {
              name = "bash";
              "auto-format" = true;
              "file-types" = ["sh" "bash" "dash" "ksh" "mksh"];
              formatter = {
                command = "shfmt";
                args = ["-i" "2"];
              };
              "language-servers" = ["bash-language-server"];
            }
          ];

          "language-server" = {
            "bash-language-server" = {
              command = "bash-language-server";
              args = ["start"];
            };
          };
        };
      }
    ];
  };
}
