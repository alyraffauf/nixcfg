# nvf's upstream maximal example, kept in one file for straightforward editing.
{
  inputs,
  lib,
  self,
  ...
}: {
  options.flake.neovimModules.default = lib.mkOption {
    type = lib.types.deferredModule;
    default = {};
    description = "The standalone nvf configuration.";
  };

  config = {
    flake.neovimModules.default = {
      config.vim = {
        viAlias = true;
        vimAlias = true;

        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        opts = {
          number = true;
          relativenumber = false;
          expandtab = true;
          shiftwidth = 0;
          tabstop = 2;
        };

        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };

        keymaps = [
          {
            key = "<leader>w";
            mode = "n";
            action = "<cmd>write<CR>";
            desc = "Save";
          }
          {
            key = "<leader>q";
            mode = "n";
            action = "<cmd>confirm quit<CR>";
            desc = "Quit window";
          }
          {
            key = "<leader>Q";
            mode = "n";
            action = "<cmd>confirm qall<CR>";
            desc = "Exit Neovim";
          }
          {
            key = "<leader>n";
            mode = "n";
            action = "<cmd>enew<CR>";
            desc = "New file";
          }
          {
            key = "<leader>/";
            mode = "n";
            action = "gcc";
            noremap = false;
            desc = "Toggle comment";
          }
          {
            key = "<leader>/";
            mode = "x";
            action = "gc";
            noremap = false;
            desc = "Toggle comment";
          }
          {
            key = "|";
            mode = "n";
            action = "<cmd>vsplit<CR>";
            desc = "Vertical split";
          }
          {
            key = "\\";
            mode = "n";
            action = "<cmd>split<CR>";
            desc = "Horizontal split";
          }
          {
            key = "<C-H>";
            mode = "n";
            action = "<C-W>h";
            desc = "Move to left split";
          }
          {
            key = "<C-J>";
            mode = "n";
            action = "<C-W>j";
            desc = "Move to below split";
          }
          {
            key = "<C-K>";
            mode = "n";
            action = "<C-W>k";
            desc = "Move to above split";
          }
          {
            key = "<C-L>";
            mode = "n";
            action = "<C-W>l";
            desc = "Move to right split";
          }
          {
            key = "<Tab>";
            mode = "x";
            action = ">gv";
            desc = "Indent selection";
          }
          {
            key = "<S-Tab>";
            mode = "x";
            action = "<gv";
            desc = "Unindent selection";
          }
        ];

        spellcheck = {
          enable = true;
          programmingWordlist.enable = false;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
          presets.harper.enable = true;
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          astro.enable = true;
          bash.enable = true;
          css.enable = true;
          docker.enable = true;
          env.enable = true;
          fish.enable = true;
          go.enable = true;
          hcl.enable = true;
          html.enable = true;
          jinja.enable = true;
          json.enable = true;
          just.enable = true;
          lua.enable = true;
          markdown.enable = true;

          nix = {
            enable = true;
            lsp.servers = ["nixd"];
          };

          python.enable = true;
          typescript.enable = true;
          typst.enable = true;
        };

        visuals = {
          blink-indent.enable = false;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          hlargs-nvim.enable = true;
          nvim-cursorline.enable = true;
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          rainbow-delimiters.enable = true;
          tiny-devicons-auto-colors.enable = true;
        };

        statusline.lualine = {
          enable = true;
          icons.enable = true;
          theme = "auto";
          setupOpts.options.theme = "catppuccin-nvim";

          integrations.breadcrumbs = {
            vanilla.enable = false;
            nvim-navic.enable = true;
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "frappe";
          transparent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete = {
          nvim-cmp.enable = false;
          blink-cmp.enable = true;
        };

        filetree.neo-tree.enable = true;
        tabline.nvimBufferline.enable = true;
        treesitter.context.enable = false;

        binds.whichKey = {
          enable = true;
          register = {
            "<leader>b" = "+Buffers";
            "<leader>d" = "+Debugger";
            "<leader>f" = "+Find";
            "<leader>g" = "+Git";
            "<leader>l" = "+Language";
            "<leader>p" = "+Plugins";
            "<leader>t" = "+Terminal";
            "<leader>u" = "+UI/UX";
            "<leader>x" = "+Diagnostics";
          };
        };
        telescope.enable = true;

        git = {
          enable = false;

          gitsigns = {
            enable = true;
            codeActions.enable = false;
          };

          neogit.enable = false;
        };

        minimap.minimap-vim.enable = true;
        dashboard.alpha.enable = false;
        notify.nvim-notify.enable = false;
        projects.project-nvim.enable = true;

        utility = {
          icon-picker.enable = true;
          surround.enable = true;
          grug-far-nvim.enable = true;
          motion.leap.enable = true;

          snacks-nvim = {
            enable = true;

            setupOpts = {
              dashboard.enabled = true;
              notifier.enabled = true;
              input.enabled = true;

              picker = {
                enabled = true;
                ui_select = true;
              };

              image.doc.enabled = false;

              indent = {
                enabled = true;
                indent.char = "▏";
                scope.enabled = true;
                scope.char = "▏";
                animate.enabled = false;
              };
            };
          };

          images = {
            image-nvim.enable = true;
            img-clip.enable = true;
          };
        };

        notes.todo-comments.enable = true;

        terminal.toggleterm = {
          enable = true;
          lazygit.enable = true;
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = true;
          illuminate.enable = true;
          fastaction.enable = true;
        };

        assistant.avante-nvim.enable = true;

        session.nvim-session-manager.enable = true;
        comments.comment-nvim.enable = true;
      };
    };

    perSystem = {pkgs, ...}: {
      packages.nvim =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [self.neovimModules.default];
        }).neovim;
    };
  };
}
