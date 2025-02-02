{pkgs, ...}: {
  config = {
    programs.helix = {
      enable = true;

      languages = {
        language-server = {
          rust-analyzer.config = {
            checkOnSave.command = "clippy";
            cargo.features = "all";
            cargo.unsetTest = [];
          };

          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
            config = {};
          };

          nil.command = "${pkgs.nil}/bin/nil";

          bash-language-server = {
            command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
            args = ["start"];
          };

          haskell = {
            command = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
            args = ["lsp"];
          };
        };

        language = [
          {
            name = "python";
            auto-format = true;
            language-servers = [{name = "pyright";}];
            formatter = {
              command = "/bin/sh";
              args = ["-c" "${pkgs.isort}/bin/isort - | ${pkgs.black}/bin/black -q -l 120 -C -"];
            };
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [{name = "nil";}];
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
          }
          {
            name = "bash";
            auto-format = true;
          }
          {
            name = "haskell";
            auto-format = true;
            language-servers = [{name = "haskell";}];
            formatter = {
              command = "${pkgs.ormolu}/bin/ormolu";
              args = ["--no-cabal"];
            };
          }
        ];
      };

      settings = {
        editor = {
          auto-completion = true;
          auto-format = true;
          auto-pairs = false;
          auto-save = true;
          color-modes = true;
          cursorline = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides.render = true;

          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };

          soft-wrap = {
            enable = true;
            wrap-at-text-width = true;
          };

          statusline.center = ["position-percentage"];
          text-width = 80;
          true-color = true;

          whitespace.characters = {
            newline = "↴";
            tab = "⇥";
          };
        };
      };
    };
  };
}
